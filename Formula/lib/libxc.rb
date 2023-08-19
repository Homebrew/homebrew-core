class Libxc < Formula
  desc "Library of exchange and correlation functionals for codes"
  homepage "https://tddft.org/programs/libxc/"
  url "https://gitlab.com/libxc/libxc/-/archive/6.2.2/libxc-6.2.2.tar.bz2"
  sha256 "ec292de621e819b03a37db1f7a7365a9eaf423e30e2fd4553e6336eca534cc29"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6bf3929d9889b0078afb09ffc285b66c268aa0d665ec21ab56e1f51ddba78a26"
    sha256 cellar: :any,                 arm64_monterey: "241a0cb7e33d79615fc390d19ea846df49893e57f08fa0561ae881c8b395d89a"
    sha256 cellar: :any,                 arm64_big_sur:  "258ac8b1c6b73472797552674aa2b51d9d145fe3a34a94e0c872ecb1e1ef1821"
    sha256 cellar: :any,                 ventura:        "2eeace080d0402fa565815e822a9a4807c47e523d6fd703ea006533b6cb85ba1"
    sha256 cellar: :any,                 monterey:       "1140249e839f5f232ba9efc1692418c12ad8ba9848370068cef81cfba2a4b3ce"
    sha256 cellar: :any,                 big_sur:        "886bef2546e6eff2896c094fdfd4ed12173b1a660fdbfe73247adbfdf47f7067"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d1a5c224164b165e6fabfdacc56bea1c3839374b130da801e1af8faf2223455"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "gcc" # for gfortran

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_FORTRAN=ON",
                    "-DBUILD_SHARED_LIBS=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Common test files for both cmake and plain
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <xc.h>
      int main()
      {
        int major, minor, micro;
        xc_version(&major, &minor, &micro);
        printf("%d.%d.%d", major, minor, micro);
      }
    EOS
    (testpath/"test.f90").write <<~EOS
      program lxctest
        use xc_f03_lib_m
      end program lxctest
    EOS
    # Simple cmake example
    (testpath / "CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.6)
      project(test_libxc LANGUAGES C Fortran)
      find_package(Libxc CONFIG REQUIRED)
      add_executable(test_c test.c)
      target_link_libraries(test_c PRIVATE Libxc::xc)
      add_executable(test_fortran test.f90)
      target_link_libraries(test_fortran PRIVATE Libxc::xcf03)
    EOS
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
