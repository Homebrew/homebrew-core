class Blaze < Formula
  desc "High-performance C++ math library for dense and sparse arithmetic"
  homepage "https://bitbucket.org/blaze-lib/blaze"
  url "https://bitbucket.org/blaze-lib/blaze/downloads/blaze-3.8.2.tar.gz"
  sha256 "4c4e1915971efbedab95790e4c5cf017d8448057fa8f8c62c46e1643bf72cbb1"
  license "BSD-3-Clause"
  head "https://bitbucket.org/blaze-lib/blaze.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "1f564399ba9c93c4246e3cf3679b5b49661edb3ad9077afab40f94c220e6d49c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a80081c26f45e68615e6ef2dcde4f354ee8dc05cf2744d20d75efee48f7e7864"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "808bf2b3fe945e77161aa0878ab93310708d2c1417a437940f4b3fb72f729822"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7517ce89404f505648d0a6c8581bee0037e03dbe9e2ff59a46ea331bbe03bbe3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e47ffe3bc0d4b023cb6aeb3a368b3758daa8f06fab8c5b701eb5e30733591bf2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e47ffe3bc0d4b023cb6aeb3a368b3758daa8f06fab8c5b701eb5e30733591bf2"
    sha256 cellar: :any_skip_relocation, sonoma:         "7db24bba973ce27f8e880f789e40d69fa6fa72397b82c2684c4571ad10d79d10"
    sha256 cellar: :any_skip_relocation, ventura:        "cdb1e443ad562ea1318c56b0aa3aa0851b3a61706937dea50e5a9b93d9c97889"
    sha256 cellar: :any_skip_relocation, monterey:       "cdb1e443ad562ea1318c56b0aa3aa0851b3a61706937dea50e5a9b93d9c97889"
    sha256 cellar: :any_skip_relocation, big_sur:        "cdb1e443ad562ea1318c56b0aa3aa0851b3a61706937dea50e5a9b93d9c97889"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "bd2428d2baba5bb1a0ee1ff74c7dc1c106d3f809306d9d0de5b271e84797b4a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0ca0507adf1a1c979a0446130bff037163e335a12cd8d0517cd83b1209ce206"
  end

  depends_on "cmake" => :build
  depends_on "openblas"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
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
    CPP

    expected = <<~EOS
      C =
      (           -1           -1 )
      (            0           -4 )
    EOS

    system ENV.cxx, "test.cpp", "-std=c++14", "-I#{include}", "-o", "test"
    assert_equal expected, shell_output(testpath/"test")
  end
end
