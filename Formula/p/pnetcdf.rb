class Pnetcdf < Formula
  desc "Parallel netCDF library for scientific data using the OpenMPI library"
  homepage "https://parallel-netcdf.github.io/index.html"
  url "https://parallel-netcdf.github.io/Release/pnetcdf-1.15.1.tar.gz"
  sha256 "169c6adab08ba49154f14261225992601c573971b823c2066008a8ff57973f8a"
  license "NetCDF"

  livecheck do
    url "https://parallel-netcdf.github.io/wiki/Download.html"
    regex(/href=.*?pnetcdf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "0b71509e01f93cc7e846ebfbd5141c75bbf673c77155026cc79c27771ffa2482"
    sha256 arm64_tahoe:       "521e5af7ae603eed617aa27e55fab4459944cf0d81393537759295c1e959e487"
    sha256 arm64_sequoia:     "26c745ad7dec7dcda1ee1b5ade59a545bed659d2a0e30b8df27ac7f18c104b87"
    sha256 arm64_linux:       "4845d6748856a9f7b8fae2eba47ad5bc7b1bbd4441d1ee164ef0d7586ca7b9d6"
    sha256 x86_64_linux:      "a19b3da41ab1828ed5751fe1ea82b966d4c4b1b7913ba28a2c8f40360375b2b4"
  end

  depends_on "gcc"
  depends_on "open-mpi"

  uses_from_macos "m4" => :build

  deny_network_access!

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
