class Pnetcdf < Formula
  desc "Parallel netCDF library for scientific data using the OpenMPI library"
  homepage "https://parallel-netcdf.github.io/index.html"
  url "https://parallel-netcdf.github.io/Release/pnetcdf-1.14.0.tar.gz"
  sha256 "e5a7e87dcf7d526b97e8ffdce05df0d2845965787a7d21242fafa9656950e402"
  license "NetCDF"

  livecheck do
    url "https://parallel-netcdf.github.io/wiki/Download.html"
    regex(/href=.*?pnetcdf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "19b8144af18eadad7d9d794d37864fa81c62e6907b5a118b9b14a8b27e4d30b0"
    sha256 arm64_sonoma:  "3385c56d53190c61d92bf85b9b3c7b92086c58b644bec5a8b66fdf4555a8ac66"
    sha256 arm64_ventura: "360874963214b4e9b9338ee78448420a150b9cb00756ebb8d5df0b97ae359320"
    sha256 sonoma:        "a46e740e91a836a35faf7ef12039280dcf14cd35a908dc6d6f65d30202436d8f"
    sha256 ventura:       "1caabb8afcf508fc98e0afc9af8d1f449c9f61c49fc003b81c040ea75147fa4d"
    sha256 x86_64_linux:  "a94a617103f87b61c162f9bd9eeff3887a5e44c507406c662034231cfd38441e"
  end

  depends_on "gcc"
  depends_on "open-mpi"

  uses_from_macos "m4" => :build

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    # Work around asm incompatibility with new linker (FB13194320)
    # https://github.com/Parallel-NetCDF/PnetCDF/issues/139
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500

    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--enable-shared"

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
