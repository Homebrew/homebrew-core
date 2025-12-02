class Gcem < Formula
  desc "C++ compile-time math library"
  homepage "https://gcem.readthedocs.io/en/latest/"
  url "https://github.com/kthohr/gcem/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "8e71a9f5b62956da6c409dda44b483f98c4a98ae72184f3aa4659ae5b3462e61"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4c337ac05dac7977ed331c345563b4ec5a023af3ec25a1fd9fe714fd812170e4"
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
      #include <gcem.hpp>

      int main() {
        constexpr int x = 10;
        std::cout << gcem::factorial(x) << std::endl;
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-o", "test"
    assert_equal "3628800\n", shell_output("./test")
  end
end
