 #/bin/bash
 module load anaconda3/4.4.0 
 source activate lee1

 echo ""
 echo "**************************************************************************"
 echo ""
 echo "This program converts from bigendian binary files (>f4) to 3D numpy matrix, extracts surface layer data at Z=0 for each month, and combines them into one array ----> 'combined.npy'."
 echo ""
 echo ""
 echo "NOTE --> Please ensure that 'convert_and_combine.sh', binary_to_npy.py' and 'combine_arrays.py' are in the same same folder as your binary '.data' files."
 echo ""
 echo "**************************************************************************"
 echo ""

 depth=0
 export depth=$depth
 export root="depth"$depth
 mkdir "depth"$depth
 echo "Please enter number of months: e.g. '6' will return months 1 to 6 combined: "
 read N
 export num_months=$N

 cwd=$(pwd)
 file_path=$cwd
 month=1
 progressbar () {
 
    trap 'break' USR1
    while printf '#' >&2; do
        sleep 0.25
    done
    
 }

 progressfoo () {
 
    progressbar & pid="$!"
    echo 'Program Running.....'
     
        for f in $file_path/*.data
        do
            export binary=$f
            python binary_to_npy.py $month
            ((month=month+1))
        done

	python combine_arrays.py
        rm $(pwd)/depth0/month*.npy
        
    kill -s USR1 "$pid"
 }

 progressfoo

 echo ""
 echo "<<<<<<<<<<<<<<<   CONVERSION AND EXTRACTION SUCCESSFUL  >>>>>>>>>>>>>>>>>>"
 echo ""
