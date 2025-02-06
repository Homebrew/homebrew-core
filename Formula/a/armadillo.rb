class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-14.2.3.tar.xz"
  sha256 "fc70c3089a8d2bb7f2510588597d4b35b4323f6d4be5db5c17c6dba20ab4a9cc"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2aabd8e573c2e528c93a0149317fac7e9076701de93da25dfd48df43d66ec0f0"
    sha256 cellar: :any,                 arm64_sonoma:  "647d43def0b59abc12e9c2c7ae9577d5044ac48fea7571afcb48c40c52ad19e4"
    sha256 cellar: :any,                 arm64_ventura: "a6a09f519fa84c5b2e5013ba8b6c88ee54f1dfd2f815d4bfcfe97e9e324a8962"
    sha256 cellar: :any,                 sonoma:        "5b099cfc9cafd5a9e33020fc6cdc7f816a3c095f5a5d8a86daa3d5ae7cd9edb6"
    sha256 cellar: :any,                 ventura:       "1a51f6b197c2fb036a4f6f92c63cfc132143b790c9ff9323117af239df49d962"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "562f9119ca59fcb919fd83d24422f89a380927dc7145428308ede07ef445df28"
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
