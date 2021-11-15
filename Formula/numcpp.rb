class Numcpp < Formula
  desc "C++ implementation of the Python Numpy library"
  homepage "https://dpilger26.github.io/NumCpp"
  url "https://github.com/dpilger26/NumCpp/archive/Version_2.6.2.tar.gz"
  sha256 "6c32dd72cc2ccaf7efbba394305c7a3e2ccf1b763d3688de7e253f9ca9b3cf4a"
  license "MIT"
  head "https://github.com/dpilger26/NumCpp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a284a6316ea835d91ff9cfeda6295ff1a3339a3dc605b5f4e926c9edf627a719"
  end

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <NumCpp.hpp>

      int main() {
          nc::NdArray<int> a = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}};
          a = nc::diagonal(a);
          for (int i = 0; i < nc::shape(a).cols; ++i)
              std::cout << a[i] << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cpp", "-o", "test", "-I#{include}"
    assert_equal "1\n5\n9\n", shell_output("./test")
  end
end
