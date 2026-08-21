class Cotila < Formula
  desc "Compile-time linear algebra system for C++"
  homepage "https://github.com/calebzulawski/cotila"
  url "https://github.com/calebzulawski/cotila/archive/refs/tags/1.2.1.tar.gz"
  sha256 "898ebfdf562cd1a3622870e17a703b38559cf2c607b2d5f79e6b3a55563af619"
  license "Apache-2.0"
  head "https://github.com/calebzulawski/cotila.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8144c977b0567dff23206cbf5e24f7fc4aed78092dd187517e8813ca1e12f495"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <cotila/cotila.h>

      int main() {
        constexpr cotila::vector<double, 3> v1 {{1., -2., 3.}};
        constexpr cotila::vector v2 {1., 2., 3.};
        static_assert(v2 == cotila::abs(v1));

        constexpr cotila::matrix<double, 2, 3> m1 {{{1., 2., 3.}, {4., 5., 6.}}};
        constexpr cotila::matrix m2 {{{1., 4.}, {2., 5.}, {3., 6.}}};
        static_assert(m2 == cotila::transpose(m1));

        constexpr cotila::matrix<std::complex<double>, 2, 2> m3 {{{{1., 0.}, {2., 1.}}, {{3., -1.}, {4., 2.}}}};
        constexpr cotila::matrix m4 {{{{1., 0.}, {3., 1.}}, {{2., -1.}, {4., -2.}}}};
        static_assert(m4 == cotila::hermitian(m3));

        constexpr double s = cotila::sqrt(4.);
        static_assert(s == 2.);
        std::cout << s << std::endl;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-o", "test"
    assert_equal "2\n", shell_output("./test")
  end
end
