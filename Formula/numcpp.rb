class Numcpp < Formula
  desc "C++ implementation of the Python Numpy library"
  homepage "https://dpilger26.github.io/NumCpp"
  url "https://github.com/dpilger26/NumCpp/archive/Version_2.3.1.tar.gz"
  sha256 "df18e4762f5a7c42b703a3ac6de545f814bf8b7fe8463646b743c85a144de294"
  license "MIT"
  head "https://github.com/dpilger26/NumCpp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cac192f81e747be1de8738a455fe0434aa326730bd898b1ca3d7128506f199c5" => :big_sur
    sha256 "4cf1e18e75ebfcb953d41eda2e63bd4861ac70a60797cff9873c2bca07a7f527" => :arm64_big_sur
    sha256 "45d1e6f87c6c253c5cd1a5b75247c2433dcbb4fe4ac5ecb6c2ac1d0d53a9f231" => :catalina
    sha256 "830cc9312d29337ac066b1861ced8846a54aeddbc7d6401796ee6490fe4881b3" => :mojave
    sha256 "e68ae1eb4314455e0efa51c8a56a2afbf18f3a8c1987b8b587611fe36966fa65" => :high_sierra
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
