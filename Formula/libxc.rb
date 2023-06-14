class Libxc < Formula
  desc "Library of exchange and correlation functionals for codes"
  homepage "https://tddft.org/programs/libxc/"
  url "https://gitlab.com/libxc/libxc/-/archive/6.2.1/libxc-6.2.1.tar.bz2"
  sha256 "fbb5a8062d82f6c0ad638a2ca83c7b0db91101343eef2cd1fe33365b282d9260"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ae3f9bd29a4ab944ad147f5b3acc5f3e9f2788bf703a1cb714f87641975e5aa5"
    sha256 cellar: :any,                 arm64_monterey: "5239ede8facc881ce88c966de4786985a40499894ca07e8553c396a0a5569bc0"
    sha256 cellar: :any,                 arm64_big_sur:  "3cba7a84370d9960405cdac29f337bffaceb65c23c47eb95fbfb7b86ba1c6666"
    sha256 cellar: :any,                 ventura:        "bf446e308eede31d68e750a025acb65e3ebfb02c8cb72c26116eb6711ccc390d"
    sha256 cellar: :any,                 monterey:       "2743834aa3b93c2e26354ffd8d9150792abcec15da534ba342816a3e591c04f3"
    sha256 cellar: :any,                 big_sur:        "e6f1c863d3e73d5cf7287518afa1e1c2df596a449bdd6f0eecb308eedc006472"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "134cea3930c08fe5836c8a1ea1185af213467dfb265c99da5a32c952efca9d93"
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
