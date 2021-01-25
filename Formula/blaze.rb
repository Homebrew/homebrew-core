class Blaze < Formula
  desc "High-performance C++ math library for dense and sparse arithmetic"
  homepage "https://bitbucket.org/blaze-lib/blaze"
  url "https://bitbucket.org/blaze-lib/blaze/downloads/blaze-3.8.tar.gz"
  sha256 "dfaae1a3a9fea0b3cc92e78c9858dcc6c93301d59f67de5d388a3a41c8a629ae"
  license "BSD-3-Clause"
  revision 1
  head "https://bitbucket.org/blaze-lib/blaze.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c05e15582afef1b0d7961736731a844b1939a8c99c1d60aa412aee5c5c5507f0" => :big_sur
    sha256 "a0ee08be16bbc07c8c3447d05768a736d577a78fdf8ad920cf4cf071cecb4ce4" => :catalina
    sha256 "d4c4f3f85b1d9f7759fa7fa9a9c850fd031fd5204b3b0beff5caa879a9561ea8" => :mojave
    sha256 "4cd2aa850c2749e6b8b9c82687e377bf48b0c97e55dba47c99182439677d042b" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "openblas"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <blaze/Math.h>

      int main() {
          blaze::DynamicMatrix<int> A( 2UL, 3UL, 0 );
          A(0,0) =  1;
          A(0,2) =  4;
          A(1,1) = -2;

          blaze::StaticMatrix<int,3UL,2UL,blaze::columnMajor> B{
              { 3, -1 },
              { 0, 2 },
              { -1, 0 }
          };

          blaze::DynamicMatrix<int> C = A * B;
          std::cout << "C =\\n" << C;
      }
    EOS

    expected = "C =\n(           -1           -1 )" \
                  "\n(            0           -4 )\n"

    system ENV.cxx, "test.cpp", "-std=c++14", "-I#{include}", "-o", "test"
    assert_equal expected, shell_output(testpath/"test")
  end
end
