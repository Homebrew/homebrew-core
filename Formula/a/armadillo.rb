class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-14.4.1.tar.xz"
  sha256 "26ce272bfdc8246c278e6f8cfa53777a1efb14ef196e88082fee05da1a463491"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5ac51127da28f670eec024765c9227d56f53159d6b6a47bf6257bf8dd7b7e8d3"
    sha256 cellar: :any,                 arm64_sonoma:  "8863d69dc4e23c05c742b450424ed68fc6e994bccacf751e135d3eca38f19871"
    sha256 cellar: :any,                 arm64_ventura: "b495e8cf5b65087f8715ec2e79cce9a345ba7365aac214858c9ef9e637d4673a"
    sha256 cellar: :any,                 sonoma:        "dc2537516e0307dfcea323be3428198e8049d88a420f890fef7eb9a9666eb27a"
    sha256 cellar: :any,                 ventura:       "7b135d1b4ac6fc89fad691fa2c0429657904d7376581e672370cccd1c35b6712"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68212db3b6dcb2df51e9c5f879e04ae353464025456e1496bb74bdec74800846"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41e6a574a9673e69e133cae07e44493890361f0e2458bcead9b938c15c5f0749"
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
