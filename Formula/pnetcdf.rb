class Pnetcdf < Formula
  desc "Parallel netCDF library for scientific data using the OpenMPI library"
  homepage "https://parallel-netcdf.github.io/index.html"
  url "https://parallel-netcdf.github.io/Release/pnetcdf-1.12.2.tar.gz"
  sha256 "3ef1411875b07955f519a5b03278c31e566976357ddfc74c2493a1076e7d7c74"
  license "NetCDF"

  bottle do
    sha256 arm64_big_sur: "050d7d04413ccbc8b015ff662dabfa5abd051e116270437125987d2378037663"
    sha256 big_sur:       "85211030d47c598d6ff4de8af6c063194d82cfd030c3799ffe61d0ea775fee91"
    sha256 catalina:      "850305bbe69b1ada59f7cc8628d12471819e720dbd41f873d269ff12ff7a9f86"
    sha256 mojave:        "7313cd18dde083b4cb5bee094a43e1138ab70f97f33e762c8d97d64d916143eb"
  end

  depends_on "gcc"
  depends_on "open-mpi"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-shared"

    cd "src/utils" do
      # Avoid references to Homebrew shims
      inreplace ["pnetcdf-config", "pnetcdf_version/Makefile"], "#{HOMEBREW_SHIMS_PATH}/mac/super/",
                                                                "/usr/bin/"
    end

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
