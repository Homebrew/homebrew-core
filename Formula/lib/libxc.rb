class Libxc < Formula
  desc "Library of exchange and correlation functionals for codes"
  homepage "https://libxc.gitlab.io/"
  url "https://gitlab.com/libxc/libxc/-/archive/7.1.2/libxc-7.1.2.tar.bz2"
  sha256 "3915fac94416e4c415534223ea492ad2663f928acf27e98662c861b094a6c306"
  license "MPL-2.0"
  compatibility_version 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "062054526dde4f93321c133195566032b58113ca69d501c26ed5c0acc3b884d3"
    sha256 cellar: :any, arm64_tahoe:       "ab2639fc70474d5f0470a8da67bce3f303071d185a470b9c059c5ce5f82d1a6a"
    sha256 cellar: :any, arm64_sequoia:     "e31f695c5452672c85950d0aa3beb4900f807b03571243b4618e047891c482a7"
    sha256 cellar: :any, arm64_linux:       "290e611de24aa5c9c3393622814de49748dab8ae2ef161b2f1a8bfbfe07e2348"
    sha256 cellar: :any, x86_64_linux:      "88f07995510971169d45b5509607d100d4d6433b14f8ec6af5d26a438d542c04"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "gcc" # for gfortran

  def install
    args = %w[
      -DENABLE_FORTRAN=ON
      -DMAXORDER=4
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
