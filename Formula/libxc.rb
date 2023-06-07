class Libxc < Formula
  desc "Library of exchange and correlation functionals for codes"
  homepage "https://tddft.org/programs/libxc/"
  url "https://gitlab.com/libxc/libxc/-/archive/6.2.0/libxc-6.2.0.tar.bz2"
  sha256 "ebc6b966357e7941ddfcec112fcd51bd9ab4300b87fc53753bde1b91fa6cab3f"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0da695748729ac08cfe6d014e8d04beb3f7354d812db6cbe7b25296ab01bb501"
    sha256 cellar: :any,                 arm64_monterey: "eb49c6a9a33ead8e9768e821b57cd054179a71d88f834e1ca763f688f7523509"
    sha256 cellar: :any,                 arm64_big_sur:  "eda99cec67b89ab486bd714dad6bce1f870e8a34b7be21227c3ceac405a025a5"
    sha256 cellar: :any,                 ventura:        "358a0fb02e8d82795c41dcba9193c2f2ffd913d4cda4d740e411bfe418387f8f"
    sha256 cellar: :any,                 monterey:       "69916f988579ea7769ca93471f920609d8c1deb9e6758b381b9a6954f94503ba"
    sha256 cellar: :any,                 big_sur:        "e30c9e0fae641a678abee80d0dfe5f83c7a8e62fe2bef9bc67483cafdcc7620e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89d7371a5e8a548ceb09c2323e7069e37e1affcedff8393b44218f1bb6f45699"
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
