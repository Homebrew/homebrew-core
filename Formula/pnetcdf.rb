class Pnetcdf < Formula
  desc "Parallel netCDF library for scientific data using the OpenMPI library"
  homepage "https://parallel-netcdf.github.io/index.html"
  url "https://parallel-netcdf.github.io/Release/pnetcdf-1.12.2.tar.gz"
  sha256 "3ef1411875b07955f519a5b03278c31e566976357ddfc74c2493a1076e7d7c74"
  license "NetCDF"
  revision 1

  livecheck do
    url "https://parallel-netcdf.github.io/wiki/Download.html"
    regex(/href=.*?pnetcdf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "2e94a26e3540b4281fce3cef0c1e965447ac4b4bd090eb816f0f91a9b0a238e2"
    sha256 arm64_big_sur:  "e15cc2caf8c4aeffa65126c52e3dceffdf6fc93dee09eed8dae9db2085756f38"
    sha256 monterey:       "7c928b2dc13add9556400b02dcc3cfdc39f89d2128896c7f401f7b1ffca16c0d"
    sha256 big_sur:        "c2f92ef84469ce44c4b502c72120a750ff64eb06b08e0ed6ebdbf74c11f026d2"
    sha256 catalina:       "4813fb99e57bd2399fe44683d58cae95638ee4a7837ef00a0fb7ef9e7151842c"
    sha256 mojave:         "845ad46ce85c49bb2e680fb2f3313bf86bce98d4dc0756be208dc60c678fb429"
  end

  depends_on "gcc"
  depends_on "open-mpi"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-shared"

    cd "src/utils" do
      # Avoid references to Homebrew shims
      inreplace ["pnetcdf-config", "pnetcdf_version/Makefile"], Superenv.shims_path, "/usr/bin"
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
