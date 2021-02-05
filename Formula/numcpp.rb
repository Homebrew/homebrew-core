class Numcpp < Formula
  desc "C++ implementation of the Python Numpy library"
  homepage "https://dpilger26.github.io/NumCpp"
  url "https://github.com/dpilger26/NumCpp/archive/Version_2.4.1.tar.gz"
  sha256 "e497f66bc3e827e34b9f5ba4ee90d1b4340d551f45af499d630cc3dd191c4894"
  license "MIT"
  head "https://github.com/dpilger26/NumCpp.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dc65d6ab452da76bc43ea0bc472adfcc6e34c868e907c6bb7b1c07d6e4c0ae9d"
    sha256 cellar: :any_skip_relocation, big_sur:       "8f553497c1071941948df03b492c1545b0e7c78993ef7319880e11860da7744e"
    sha256 cellar: :any_skip_relocation, catalina:      "f87c93639d7fa92051882b55f0878d3bd6ca4ec0d7fced6432bef13280869271"
    sha256 cellar: :any_skip_relocation, mojave:        "c93e65a45a86781f6f7f3d86b80e616ac57c2f79e1ecff27b97dfe549d63c5f7"
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
