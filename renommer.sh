#!/bin/bash

# Exclure le script lui-même
shopt -s extglob

# Renommer les fichiers en ajoutant "pièce numéro"
rename 's/(.*)/Dossier Chabane VS Immobiliére 3F: Pièce Numéro $1/' !("renommer_et_filigrane.sh")

# Ajouter un chiffre croissant à chaque nom de fichier
count=1

for file in *; do
    # Exclure le script lui-même
    if [[ "$file" != "renommer_et_filigrane.sh" ]]; then
        mv "$file" "pièce numéro $count - $file"
        ((count++))
    fi
done

# Boucle à travers chaque fichier PDF dans le dossier
for file in *.pdf; do
    # Créer un nom de fichier temporaire pour le filigrane
    watermark_temp=$(mktemp)

    # Convertir le fichier PDF contenant le filigrane en forme de cercle en PDF avec un fond transparent
    convert -size $(pdfinfo "$file" | grep "Page size" | awk '{print $3"x"$5}' | tr -d ',') xc:none -fill none -draw "circle $(pdfinfo "$file" | grep "Page size" | awk '{print $3/2","$5/2" "$(sqrt($3^2+$5^2)/2)}')" "$watermark_temp"

    # Ajouter le filigrane en forme de cercle à chaque page du fichier PDF d'origine
    pdftk "$file" multibackground "$watermark_temp" output "watermarked_$file"

    # Supprimer le fichier temporaire du filigrane
    rm "$watermark_temp"
