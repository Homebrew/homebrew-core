class Numcpp < Formula
  desc "C++ implementation of the Python Numpy library"
  homepage "https://dpilger26.github.io/NumCpp"
  url "https://github.com/dpilger26/NumCpp/archive/Version_2.4.2.tar.gz"
  sha256 "8da0494552796b76e5e9ef691176fa7cb27bc52fec4019da20bfd8fb7ba00b91"
  license "MIT"
  head "https://github.com/dpilger26/NumCpp.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "51d96b14f97021af57e0fe9186e0bfca585d8482d5f375ee4d46247cba800e37"
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
