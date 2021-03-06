#!/bin/bash
# split.sh
# 
# This script splits pages from a book scan when there are two pages on
# one scan. It splits the scan in half so each page gets its own image.
#
if [ ! -e split-pages ]; 
    then mkdir split-pages; 
fi

first="`ls -1 *.tiff | head -n1`"
prefix="_Page_"
file_ext=".tiff"

let "halfwidth=` identify -format '%w \n' "$first"`/2"

width="`identify -format '%w \n' "$first"`"
height="`identify -format '%h \n' "$first"`"

# Split each page and place into newly created directory.
for FILE in *.tiff;
    do convert -crop "$halfwidth"x"$height"+0+0 "$FILE" "${FILE%%.tiff}-A.tiff"; 
       mv `ls *.tiff | grep A` split-pages;  
       convert -crop "$width"x"$height"+"$halfwidth"+0 "$FILE" "${FILE%%.tiff}-B.tiff" && mv `ls *.tiff | grep B` split-pages
    done;

cd "split-pages"

# Rename the pages for convenience.
i=1
for FILE in *.tiff;
    do page_number="$(printf %003d $i)";
       new_file="$(echo "${prefix}${page_number}${file_ext}")";
       touch "./$new_file";
       mv $FILE "./$new_file";
       i=$((i+1));
    done;
    
cd ..

