class Netcdf < Formula
  desc "Libraries and data formats for array-oriented scientific data"
  homepage "https://www.unidata.ucar.edu/software/netcdf"
  url "https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-c-4.8.0.tar.gz"
  mirror "https://www.gfd-dennou.org/arch/netcdf/unidata-mirror/netcdf-c-4.8.0.tar.gz"
  sha256 "679635119a58165c79bb9736f7603e2c19792dd848f19195bf6881492246d6d5"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/Unidata/netcdf-c.git", branch: "main"

  livecheck do
    url "https://www.unidata.ucar.edu/downloads/netcdf/"
    regex(/href=.*?netcdf-c[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "0c50d7fa0859656c1eb01da3de8be9eba53189c6038a901da6679746915fdb32"
    sha256 cellar: :any,                 big_sur:       "71057c8d7e1ebb521973d2f5841f0b1d093df47cbd930091ee0add6f58e91f53"
    sha256 cellar: :any,                 catalina:      "e75f036bc6f9a8979ab702b9293c5eaede59d7721f1e05ce62ff9b87cb224398"
    sha256 cellar: :any,                 mojave:        "15488b7028f4b086ebe2e540cbbfd2e8c6109593ed33a14af467addc84faf9f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2ad1d7bc3c8aecd74b25592f154dc7290b6c607199212baf3e96a087025b0ef"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "hdf5"

  uses_from_macos "curl"

  resource "cxx" do
    url "https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-cxx4-4.3.1.tar.gz"
    mirror "https://www.gfd-dennou.org/arch/netcdf/unidata-mirror/netcdf-cxx4-4.3.1.tar.gz"
    sha256 "6a1189a181eed043b5859e15d5c080c30d0e107406fbb212c8fb9814e90f3445"
  end

  resource "fortran" do
    # Source tarball at official domains are missing some configuration files
    # Switch back at version bump
    url "https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.5.3.tar.gz"
    sha256 "c6da30c2fe7e4e614c1dff4124e857afbd45355c6798353eccfa60c0702b495a"
  end

  def install
    ENV.deparallelize

    common_args = std_cmake_args << "-DBUILD_TESTING=OFF"

    mkdir "build" do
      args = common_args.dup
      args << "-DNC_EXTRA_DEPS=-lmpi" if Tab.for_name("hdf5").with? "mpi"
      args << "-DENABLE_TESTS=OFF" << "-DENABLE_NETCDF_4=ON" << "-DENABLE_DOXYGEN=OFF"

      # Extra CMake flags for compatibility with hdf5 1.12
      # Remove with the following PR lands in a release:
      # https://github.com/Unidata/netcdf-c/pull/1973
      args << "-DCMAKE_C_FLAGS='-I#{Formula["hdf5"].include} -DH5_USE_110_API'"

      system "cmake", "..", "-DBUILD_SHARED_LIBS=ON", *args
      system "make", "install"
      system "make", "clean"
      system "cmake", "..", "-DBUILD_SHARED_LIBS=OFF", *args
      system "make"
      lib.install "liblib/libnetcdf.a"
    end

    # Add newly created installation to paths so that binding libraries can
    # find the core libs.
    args = common_args.dup << "-DNETCDF_C_LIBRARY=#{lib}/#{shared_library("libnetcdf")}"

    cxx_args = args.dup
    cxx_args << "-DNCXX_ENABLE_TESTS=OFF"
    resource("cxx").stage do
      mkdir "build-cxx" do
        system "cmake", "..", "-DBUILD_SHARED_LIBS=ON", *cxx_args
        system "make", "install"
        system "make", "clean"
        system "cmake", "..", "-DBUILD_SHARED_LIBS=OFF", *cxx_args
        system "make"
        lib.install "cxx4/libnetcdf-cxx4.a"
      end
    end

    fortran_args = args.dup
    fortran_args << "-DENABLE_TESTS=OFF"

    # Fix for netcdf-fortran with GCC 10, remove with next version
    ENV.prepend "FFLAGS", "-fallow-argument-mismatch"

    resource("fortran").stage do
      mkdir "build-fortran" do
        system "cmake", "..", "-DBUILD_SHARED_LIBS=ON", *fortran_args
        system "make", "install"
        system "make", "clean"
        system "cmake", "..", "-DBUILD_SHARED_LIBS=OFF", *fortran_args
        system "make"
        lib.install "fortran/libnetcdff.a"
      end
    end

    # Remove some shims path
    inreplace [
      bin/"nf-config", bin/"ncxx4-config", bin/"nc-config",
      lib/"pkgconfig/netcdf.pc", lib/"pkgconfig/netcdf-fortran.pc",
      lib/"cmake/netCDF/netCDFConfig.cmake",
      lib/"libnetcdf.settings", lib/"libnetcdf-cxx.settings"
    ], Superenv.shims_path/ENV.cc, ENV.cc

    if OS.linux?
      inreplace bin/"ncxx4-config", Superenv.shims_path/ENV.cxx, ENV.cxx
    else
      # SIP causes system Python not to play nicely with @rpath
      libnetcdf = (lib/"libnetcdf.dylib").readlink
      macho = MachO.open("#{lib}/libnetcdf-cxx4.dylib")
      macho.change_dylib("@rpath/#{libnetcdf}", "#{lib}/#{libnetcdf}")
      macho.write!
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include "netcdf_meta.h"
      int main()
      {
        printf(NC_VERSION);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lnetcdf",
                   "-o", "test"
    if head?
      assert_match(/^\d+(?:\.\d+)+/, `./test`)
    else
      assert_equal version.to_s, `./test`
    end

    (testpath/"test.f90").write <<~EOS
      program test
        use netcdf
        integer :: ncid, varid, dimids(2)
        integer :: dat(2,2) = reshape([1, 2, 3, 4], [2, 2])
        call check( nf90_create("test.nc", NF90_CLOBBER, ncid) )
        call check( nf90_def_dim(ncid, "x", 2, dimids(2)) )
        call check( nf90_def_dim(ncid, "y", 2, dimids(1)) )
        call check( nf90_def_var(ncid, "data", NF90_INT, dimids, varid) )
        call check( nf90_enddef(ncid) )
        call check( nf90_put_var(ncid, varid, dat) )
        call check( nf90_close(ncid) )
      contains
        subroutine check(status)
          integer, intent(in) :: status
          if (status /= nf90_noerr) call abort
        end subroutine check
      end program test
    EOS
    system "gfortran", "test.f90", "-L#{lib}", "-I#{include}", "-lnetcdff",
                       "-o", "testf"
    system "./testf"
  end
end
