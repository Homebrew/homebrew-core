class Pnetcdf < Formula
  desc "Parallel netCDF library for scientific data using the OpenMPI library"
  homepage "https://parallel-netcdf.github.io/index.html"
  url "https://parallel-netcdf.github.io/Release/pnetcdf-1.11.2.tar.gz"
  sha256 "d2c18601b364c35b5acb0a0b46cd6e14cae456e0eb854e5c789cf65f3cd6a2a7"

  bottle do
    sha256 "239d0fd91972dfae7429806a40f286deecaa7e4ce960c7aa7ccecc6e99fe97c0" => :catalina
    sha256 "73b60ef9536af78adbe654dcc49da037b27cc8ce373f36543c6da1b1a1bbaaa9" => :mojave
    sha256 "f03941617d9d7260497e1f89079eb7ca4c98fbd36d5bfcfa62d298e6790d6350" => :high_sierra
  end

  depends_on "gcc"
  depends_on "open-mpi"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-shared"
    system "make", "install"
  end

  # These tests were converted from the netcdf formula.
  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include "pnetcdf.h"
      int main()
      {
        printf(PNETCDF_VERSION);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lpnetcdf",
                   "-o", "test"
    assert_equal `./test`, version.to_s

    (testpath/"test.f90").write <<~EOS
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
    EOS
    system "mpif90", "test.f90", "-L#{lib}", "-I#{include}", "-lpnetcdf",
                       "-o", "testf"
    system "./testf"
  end
end
