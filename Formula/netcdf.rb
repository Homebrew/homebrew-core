class Netcdf < Formula
  desc "Libraries and data formats for array-oriented scientific data"
  homepage "https://www.unidata.ucar.edu/software/netcdf/"
  url "https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.8.1.tar.gz"
  sha256 "bc018cc30d5da402622bf76462480664c6668b55eb16ba205a0dfb8647161dd0"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/Unidata/netcdf-c.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:netcdf[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "d60a8042de5cc5cc62ed9eb79fabddade5d88e4f70360b5b793566b5f601ed63"
    sha256 cellar: :any,                 arm64_big_sur:  "f3afbed42ee2f16a125fed4f4195dab61265645991bc6b611cefe5997472ea45"
    sha256 cellar: :any,                 monterey:       "4116d43312130dd84f24154880cf376152dd1347569f4a4d2c57b1c9a06e1542"
    sha256 cellar: :any,                 big_sur:        "2deb28d80ce93556f52152df2670893ac32d86fb72bb5fb61b0b6ef20bd3be3b"
    sha256 cellar: :any,                 catalina:       "0b93b2bb0131842c248871008bbe7221ca1616feb8cadafa72a43c85c822218e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ee9135286cb4c082d41b4953541832d1677e3ff8e95454e17627fe7e165e2fc"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "hdf5"

  uses_from_macos "curl"

  resource "cxx" do
    url "https://downloads.unidata.ucar.edu/netcdf-cxx/4.3.1/netcdf-cxx4-4.3.1.tar.gz"
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

    inreplace bin/"ncxx4-config", Superenv.shims_path/ENV.cxx, ENV.cxx if OS.linux?
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
