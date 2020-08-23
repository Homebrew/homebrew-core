class Numcpp < Formula
  desc "C++ implementation of the Python Numpy library"
  homepage "https://dpilger26.github.io/NumCpp"
  url "https://github.com/dpilger26/NumCpp/archive/Version_2.2.0.tar.gz"
  sha256 "f434cf3c27b4eec6637dea3a508a6730d35c47b810b00cfe98ff6f0d7795787c"
  license "MIT"
  head "https://github.com/dpilger26/NumCpp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a52593f4d24ab2a416f0b3ddda28d0d58f2b429cd986f005d0d9246c9bf63dd0" => :catalina
    sha256 "6772bdab82ef5b03cab645d3b64d537ef58755f794c102c36eb56a8a45b4e369" => :mojave
    sha256 "3a8f07d4cd0695bf8f6ceda9f8e771ac71bac7c35ec4c91d720e05ffd4db35b2" => :high_sierra
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
