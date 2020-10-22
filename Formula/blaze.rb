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
    sha256 "0b6eea6a400363549d96c9093a8987653c966580c39c2e96b223a9139974636b" => :catalina
    sha256 "5dd4f2b4876abb2b483c3a8a529e0019cef7e6ee62631d10d041ca6d377f5ca9" => :mojave
    sha256 "99d8e68c81380e11226786f2843b476d782e305fc0a78dbf0fc095b659a9fe50" => :high_sierra
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
