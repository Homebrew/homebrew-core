class Libxc < Formula
  desc "Library of exchange and correlation functionals for codes"
  homepage "https://libxc.gitlab.io/"
  url "https://gitlab.com/libxc/libxc/-/archive/7.0.0/libxc-7.0.0.tar.bz2"
  sha256 "e9ae69f8966d8de6b7585abd9fab588794ada1fab8f689337959a35abbf9527d"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "aa85b3a74a71bfa20b5298f35fef63fe1738a0c85a978ab1fbf94b56c1bf168c"
    sha256 cellar: :any,                 arm64_sonoma:  "ba31c84f6c649d6b133a62d0c69a0b6c92fdb9d9e6ef959abd527fca75b43652"
    sha256 cellar: :any,                 arm64_ventura: "8a8f6c2dedb5446e4e0dfb6eef6c38acb7a134a2559e3828c2b7bca7c6cff747"
    sha256 cellar: :any,                 sonoma:        "6bcdc1b4b2820d7124c5b4c0b39566ff52cac816054945a960ef1c3a43838308"
    sha256 cellar: :any,                 ventura:       "1f2419e77039100f1a1adc062484e54a0866944235db1695fda292a0ea024894"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfd3bd380e66af839073487bcdb4934684b437f48b8880334cdc2afed1e4782c"
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
