class Pnetcdf < Formula
  desc "Parallel netCDF library for scientific data using the OpenMPI library"
  homepage "https://parallel-netcdf.github.io/index.html"
  url "https://parallel-netcdf.github.io/Release/pnetcdf-1.13.0.tar.gz"
  sha256 "aba0f1c77a51990ba359d0f6388569ff77e530ee574e40592a1e206ed9b2c491"
  license "NetCDF"

  livecheck do
    url "https://parallel-netcdf.github.io/wiki/Download.html"
    regex(/href=.*?pnetcdf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "e52824c134f9eb96f275957299545a72e92963705e05dfa59698951375d75a38"
    sha256 arm64_ventura:  "04676a0d86731dbaca40fd17affa92edba088ea67a0bad5a32ad12d286a20b18"
    sha256 arm64_monterey: "d6403f0fed304282c8aebedc23201ed53bc423e82e5a530a01261b9787187bc4"
    sha256 sonoma:         "55004aad90dc107723bca3f7e42c5baad286e5f90fb52eec7c80894df1d67e91"
    sha256 ventura:        "10a21cf8322f50f42d3005ddf7d8d6db95121a4f8aa5aeda90f4fcd6a99f9d76"
    sha256 monterey:       "bf4f1b0d560aace1914df880d4cf76de30f10dbb30e9be68e08262bd8a8ec102"
    sha256 x86_64_linux:   "af9119a49000afd8cdcd1e6c7bcc4becb886cbc3c37180c72f268fd842e90aff"
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
