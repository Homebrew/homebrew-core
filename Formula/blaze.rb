class Blaze < Formula
  desc "High-performance C++ math library for dense and sparse arithmetic"
  homepage "https://bitbucket.org/blaze-lib/blaze"
  url "https://bitbucket.org/blaze-lib/blaze/downloads/blaze-3.8.1.tar.gz"
  sha256 "a084c6d1acc75e742a1cdcddf93d0cda0d9e3cc4014c246d997a064fa2196d39"
  license "BSD-3-Clause"
  head "https://bitbucket.org/blaze-lib/blaze.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56c29be29451bf0ad3ba1a644f859bb55c36a655c5ae26cf3808218819443ff3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56c29be29451bf0ad3ba1a644f859bb55c36a655c5ae26cf3808218819443ff3"
    sha256 cellar: :any_skip_relocation, monterey:       "f9dd9f5ebcc97bad584ef931e68d9bf160ffa8f5ebb5443f53ce8ca8a39a4504"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9dd9f5ebcc97bad584ef931e68d9bf160ffa8f5ebb5443f53ce8ca8a39a4504"
    sha256 cellar: :any_skip_relocation, catalina:       "f9dd9f5ebcc97bad584ef931e68d9bf160ffa8f5ebb5443f53ce8ca8a39a4504"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "498f8d2f640474b8304983d8ec8753e3c038577bd24122808fd8ab23f4c57e19"
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

    expected = <<~EOS
      C =
      (           -1           -1 )
      (            0           -4 )
    EOS

    system ENV.cxx, "test.cpp", "-std=c++14", "-I#{include}", "-o", "test"
    assert_equal expected, shell_output(testpath/"test")
  end
end
