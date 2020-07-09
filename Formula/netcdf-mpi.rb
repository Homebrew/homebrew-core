class NetcdfMpi < Formula
  desc "The NetCDF C I/O library compiled with MPI parallel features enabled"
  homepage "https://www.unidata.ucar.edu/software/netcdf/"
  url "https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-c-4.7.4.tar.gz"
  sha256 "0e476f00aeed95af8771ff2727b7a15b2de353fb7bb3074a0d340b55c2bd4ea8"
  license "BSD-3-Clause"

  depends_on "gcc" # for gfortran
  depends_on "hdf5-mpi"

  uses_from_macos "curl" # for dap

  conflicts_with "netcdf", :because => "netcdf-mpi is an MPI parallel build, use either netcdf or netcdf-mpi"

  def install
    # move files that NetCDF wants to place in libdir,
    # because brew does not want them there.
    inreplace "./Makefile.in",
          "settingsdir = $(libdir)",
          "settingsdir = #{pkgshare}"

    system "./configure", "--enable-shared",
                          "--enable-static",
                          "--enable-fortran",
                          "--enable-dap",
                          "--enable-netcdf-4",
                          "--enable-parallel4",
                          "--prefix=#{prefix}",
                          "CC=mpicc"

    system "make", "install"
  end

  test do
    # check nc-config for presence of the MPI feature
    assert_equal "yes", shell_output("#{bin}/nc-config --has-parallel4").strip

    # compile and run a version test
    (testpath/"test_ver.c").write <<~EOS
      #include <stdio.h>
      #include "netcdf_meta.h"
      int main()
      {
        printf(NC_VERSION);
        return 0;
      }
    EOS

    system ENV.cc, "test_ver.c", "-L#{lib}", "-I#{include}", "-lnetcdf",
                   "-o", "test_ver"

    assert_equal version.to_s, `./test_ver`

    # compile and link a serial program.
    (testpath/"test_ser.c").write <<~EOS
      #include <stdio.h>
      #include "netcdf.h"
      int main()
      {
        const char *fn = "./test.nc";
        int fh = 0;
        size_t dim0 = 4;
        int dim0_id = 0;
        int var0_id = 0;
        float var0[4] = {0.f, 1.f, 2.f, 3.f};
        size_t start = 0;
        size_t count = 4;
        int ierr = 0;
        /* open the file */
        if ((ierr = nc_create(fn, NC_CLOBBER|NC_NETCDF4, &fh)) != NC_NOERR)
        {
          fprintf(stderr, "Error: creating file %s. %s\\n", fn, nc_strerror(ierr));
          return  -1;
        }
        /* define the variable dimension */
        if ((ierr = nc_def_dim(fh, "dim0", dim0, &dim0_id)) != NC_NOERR)
        {
          fprintf(stderr, "Error: failed to define dim0. %s\\n", nc_strerror(ierr));
          return  -1;
        }
        /* define the variable */
        if ((ierr = nc_def_var(fh, "var0", NC_FLOAT, 1, &dim0_id, &var0_id)) != NC_NOERR)
        {
          fprintf(stderr, "Error: failed to define var0. %s\\n", nc_strerror(ierr));
          return  -1;
        }
        /* close the header */
        nc_enddef(fh);
        /* write the data */
        if ((ierr = nc_put_vara(fh, var0_id, &start, &count, var0)) != NC_NOERR)
        {
          fprintf(stderr, "Error: failed to write dim0. %s\\n", nc_strerror(ierr));
          return  -1;
        }
        /* close the file */
        if ((ierr = nc_close(fh)) != NC_NOERR)
        {
          fprintf(stderr, "Error: closing file. %s\\n", nc_strerror(ierr));
          return  -1;
        }
        return 0;
      }
    EOS

    system ENV.cc, "test_ser.c", "-L#{lib}", "-I#{include}", "-lnetcdf",
                   "-o", "test_ser"

    system "./test_ser"

    # compile and link a parallel program.
    (testpath/"test_par.c").write <<~EOS
      #include <stdio.h>
      #include <mpi.h>
      #include "netcdf.h"
      #include "netcdf_par.h"
      int main(int argc, char **argv)
      {
        const char *fn = "./testp4.nc";
        int fh = 0;
        size_t dim0 = 4;
        int dim0_id = 0;
        int var0_id = 0;
        float var0[] = {0.f, 1.f, 2.f, 3.f, 4.f, 5.f, 6.f, 7.f, 8.f, 9.f};
        size_t start = 0;
        size_t count = 4;
        int ierr = 0;
        int rank = 1;
        int n_ranks = 1;
        /*initalize MPI */
        MPI_Init(&argc, &argv);
        /* parallel I/O w/ up to 5 ranks */
        MPI_Comm_rank(MPI_COMM_WORLD, &rank);
        MPI_Comm_size(MPI_COMM_WORLD, &n_ranks);
        if (n_ranks > 5)
        {
          fprintf(stderr, "This test requires no more than 5 ranks\\n");
          return -1;
        }
        /* each rank writes 2 values */
        dim0 = 2*n_ranks;
        start = rank*2;
        count = 2;
        fprintf(stderr, "rank %d of %d writing start=%zu, count=%zu\\n",
          rank, n_ranks, start, count);
        /* open the file */
        if ((ierr = nc_create_par(fn, NC_CLOBBER|NC_NETCDF4,
          MPI_COMM_WORLD, MPI_INFO_NULL, &fh)) != NC_NOERR)
        {
          fprintf(stderr, "Error: creating file %s. %s\\n", fn, nc_strerror(ierr));
          return  -1;
        }
        /* define the variable dimension */
        if ((ierr = nc_def_dim(fh, "dim0", dim0, &dim0_id)) != NC_NOERR)
        {
          fprintf(stderr, "Error: failed to define dim0. %s\\n", nc_strerror(ierr));
          return  -1;
        }
        /* define the variable */
        if ((ierr = nc_def_var(fh, "var0", NC_FLOAT, 1, &dim0_id, &var0_id)) != NC_NOERR)
        {
          fprintf(stderr, "Error: failed to define var0. %s\\n", nc_strerror(ierr));
          return  -1;
        }
        /* close the header */
        nc_enddef(fh);
        /* write the data */
        if ((ierr = nc_put_vara(fh, var0_id, &start, &count, var0+2*rank)) != NC_NOERR)
        {
          fprintf(stderr, "Error: failed to write dim0. %s\\n", nc_strerror(ierr));
          return  -1;
        }
        /* close the file */
        if ((ierr = nc_close(fh)) != NC_NOERR)
        {
          fprintf(stderr, "Error: closing file. %s\\n", nc_strerror(ierr));
          return  -1;
        }
        /* shut down MPI */
        MPI_Finalize();
        return 0;
      }
    EOS

    system "mpicc", "test_par.c", "-L#{lib}", "-I#{include}", "-lnetcdf",
                   "-o", "test_par"

    system "mpiexec", "-np", "2", "./test_par"
  end
end
