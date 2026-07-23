class Libxc < Formula
  desc "Library of exchange and correlation functionals for codes"
  homepage "https://libxc.gitlab.io/"
  url "https://gitlab.com/libxc/libxc/-/archive/7.1.2/libxc-7.1.2.tar.bz2"
  sha256 "3915fac94416e4c415534223ea492ad2663f928acf27e98662c861b094a6c306"
  license "MPL-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "36ceab6672413b88774dcd6c5302373c04f1939cdc63d33e5e246bd518e04fd3"
    sha256 cellar: :any, arm64_sequoia: "81b347bd4601b6ac8d1ce2fbb7860d1c4dd6ceaa7187e4892e4b48d981dc6e14"
    sha256 cellar: :any, arm64_sonoma:  "ad24be426a5360d6ee4c925a3f5c1018d190359599db5af778577564e4b7c465"
    sha256 cellar: :any, sonoma:        "b2a272a41e3c89fa5c9add783a63870d40b04f87c48b576f824ca7ca17489c26"
    sha256 cellar: :any, arm64_linux:   "668fd9c3e4a8ed139ba3a5cbc670b77dc506685b9dc418e4fce978b22b63dfe1"
    sha256 cellar: :any, x86_64_linux:  "12d1783769b29a461f77b8123f808b981247666ba4f45e7af67343f4b7def838"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "gcc" # for gfortran

  def install
    args = %w[
      -DENABLE_FORTRAN=ON
      -DDISABLE_KXC=OFF
      -DDISABLE_LXC=OFF
      -DBUILD_SHARED_LIBS=ON
    ]
    # Workaround to build with CMake 4
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Common test files for both cmake and plain
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <xc.h>
      int main()
      {
        int major, minor, micro;
        xc_version(&major, &minor, &micro);
        printf("%d.%d.%d", major, minor, micro);
      }
    C
    (testpath/"test.f90").write <<~FORTRAN
      program lxctest
        use xc_f03_lib_m
      end program lxctest
    FORTRAN
    # Simple cmake example
    (testpath / "CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.6)
      project(test_libxc LANGUAGES C Fortran)
      find_package(Libxc CONFIG REQUIRED)
      add_executable(test_c test.c)
      target_link_libraries(test_c PRIVATE Libxc::xc)
      add_executable(test_fortran test.f90)
      target_link_libraries(test_fortran PRIVATE Libxc::xcf03)
    CMAKE
    # Test cmake build
    system "cmake", "-B", "build"
    system "cmake", "--build", "build"
    system "./build/test_c"
    system "./build/test_fortran"
    # Test compilers directly
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lxc", "-o", "ctest", "-lm"
    system "./ctest"
    system "gfortran", "test.f90", "-L#{lib}", "-lxc", "-I#{include}",
                       "-o", "ftest"
    system "./ftest"
  end
end
