class Pnetcdf < Formula
  desc "Parallel netCDF library for scientific data using the OpenMPI library"
  homepage "https://parallel-netcdf.github.io/index.html"
  url "https://parallel-netcdf.github.io/Release/pnetcdf-1.14.1.tar.gz"
  sha256 "6f0f7221006c211fce9ddd2c008796b8c69dd717b2ad1be0b4027fc328fd3220"
  license "NetCDF"

  livecheck do
    url "https://parallel-netcdf.github.io/wiki/Download.html"
    regex(/href=.*?pnetcdf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "bf7af9e280e7cd4ed65b1224c5162e438019e694acaddf3879fb762df70b9613"
    sha256 arm64_sequoia: "ec1741e4908ba779f792995be4683b91815886f71a064e528e386ad4a0f6da25"
    sha256 arm64_sonoma:  "574fb8c333ad1b5c41f411214c8aafc8c16bba0fdae87adab77e0f156c14bc3b"
    sha256 sonoma:        "b81de914fd1a1240034c507f426aa28b0cf959abd106824cf39fd7e030a1481a"
    sha256 arm64_linux:   "f14a3eb2fdc8bdf79d7958132945e8756f9b5af261961efc7d943266b20a87cf"
    sha256 x86_64_linux:  "8a3e4533fbc8a1a5d1267dfe81cb3a1ab389ac4b0971de4eb6ade996bc2cc7a6"
  end

  depends_on "gcc"
  depends_on "open-mpi"

  uses_from_macos "m4" => :build

  def install
    system "./configure", "--disable-silent-rules",
                          "--enable-shared",
                          *std_configure_args
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
