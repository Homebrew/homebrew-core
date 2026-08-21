class Pnetcdf < Formula
  desc "Parallel netCDF library for scientific data using the OpenMPI library"
  homepage "https://parallel-netcdf.github.io/index.html"
  url "https://parallel-netcdf.github.io/Release/pnetcdf-1.15.0.tar.gz"
  sha256 "39813fe91ec901c7cfca3212731edbb5201029ebf55caeaaaa08d9e33c6bad65"
  license "NetCDF"

  livecheck do
    url "https://parallel-netcdf.github.io/wiki/Download.html"
    regex(/href=.*?pnetcdf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "3e099c299cd39a2e9ec03b607f1e4e790ea3d57efff82a62447eeb707a1b25fc"
    sha256 arm64_sequoia: "6930f5b42b302421a98a35eade739c28180ff1d6ec327643924a0565ea55de1b"
    sha256 arm64_sonoma:  "4c0380dff4533ae2bd1ab9f83bcd74e9df84f5e7cf4591fd893b19862401dd2d"
    sha256 sonoma:        "41df2dee0ffa0db39829510ce306110b1892e3caa9219f298c8161e7d714ea47"
    sha256 arm64_linux:   "793ed327d2a4b2f1eaf269652cc7daf9e9ee71c15ed6d3790761085c1f533599"
    sha256 x86_64_linux:  "439b71f099c530df58080a4fa6a3c0bf9fa6e0e5a286025b6ad105455b2114f4"
  end

  depends_on "gcc"
  depends_on "open-mpi"

  uses_from_macos "m4" => :build

  def install
    system "./configure", "--disable-silent-rules",
                          "--enable-shared",
                          *std_configure_args

    # Avoid references to Homebrew shims in the pnetcdf_version binary.
    inreplace "src/utils/pnetcdf_version/Makefile", "#{Superenv.shims_path}/", ""

    system "make", "install"
  end

  # These tests were converted from the netcdf formula.
  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include "pnetcdf.h"
      int main()
      {
        printf(PNETCDF_VERSION);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lpnetcdf",
                   "-o", "test"
    assert_equal `./test`, version.to_s

    (testpath/"test.f90").write <<~FORTRAN
      program test
        use mpi
        use pnetcdf
        integer :: ncid, varid, dimids(2), ierr
        integer :: dat(2,2) = reshape([1, 2, 3, 4], [2, 2])
        call mpi_init(ierr)
        call check( nfmpi_create(MPI_COMM_WORLD, "test.nc", NF_CLOBBER, MPI_INFO_NULL, ncid) )
        call check( nfmpi_def_dim(ncid, "x", 2_MPI_OFFSET_KIND, dimids(2)) )
        call check( nfmpi_def_dim(ncid, "y", 2_MPI_OFFSET_KIND, dimids(1)) )
        call check( nfmpi_def_var(ncid, "data", NF_INT, 2, dimids, varid) )
        call check( nfmpi_enddef(ncid) )
        call check( nfmpi_put_var_int_all(ncid, varid, dat) )
        call check( nfmpi_close(ncid) )
        call mpi_finalize(ierr)
      contains
        subroutine check(status)
          integer, intent(in) :: status
          if (status /= nf_noerr) call abort
        end subroutine check
      end program test
    FORTRAN
    system "mpif90", "test.f90", "-L#{lib}", "-I#{include}", "-lpnetcdf",
                       "-o", "testf"
    system "./testf"
  end
end
