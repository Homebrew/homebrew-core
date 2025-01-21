class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-14.2.2.tar.xz"
  sha256 "3054c8e63db3abdf1a5c8f9fdb7e6b4ad833f9bcfb58324c0ff86de0784c70e0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2efeccdffc1dccef21e2a5316a48213b8b3a0c03d2861670b4f7eec0967a7126"
    sha256 cellar: :any,                 arm64_sonoma:  "2fd981a76e78e48c2543e556676f723d8b23ea2809605376d8857ef23637d404"
    sha256 cellar: :any,                 arm64_ventura: "fed3300252c9dfb159037f22f01ee7f2c5348c5cf0f6af7b983c36e21ac0d717"
    sha256 cellar: :any,                 sonoma:        "c861f22bfbde5203a5b61faf0770546809446c5fcd87e72831b5f09da3dd9e35"
    sha256 cellar: :any,                 ventura:       "883a17694b505ce8d0c0609f614a29f4da9283f48f64ad8e50fb5cfaab0e570f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8518406c376b687264ea9e30bd3708e8994d9d5a9f73ee03b7b763eda8e0f52b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "arpack"
  depends_on "openblas"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DALLOW_OPENBLAS_MACOS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <armadillo>

      int main(int argc, char** argv) {
        std::cout << arma::arma_version::as_string() << std::endl;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{lib}", "-larmadillo", "-o", "test"
    assert_equal version.to_s.to_i, shell_output("./test").to_i
  end
end
