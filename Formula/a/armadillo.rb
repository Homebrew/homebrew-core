class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-15.4.0.tar.xz"
  sha256 "f781e9d935db7e8b9a64c58b6a817354d38a1769e179b477364f5e6414953f6c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2d558bb70471fb9e2c7af34e1c4d62a58bb15cca00651d274920baa4fdd305f3"
    sha256 cellar: :any, arm64_sequoia: "2f1f0538d955032b2f2c8b8399d0629ae5b69c2033f49d8184c91362ce97a108"
    sha256 cellar: :any, arm64_sonoma:  "de19e1c809d3a664f6800f6bb77e9297da502ad590525455246761dcb005f81b"
    sha256 cellar: :any, sonoma:        "fbb962a85ec7d8d6c52251343e6c955f3ff4a133adbbe512559381608bd80c5f"
    sha256 cellar: :any, arm64_linux:   "3b754b9a57b83f1e597795083d1852df34cea47b9a9c0063f60680ae1999bfed"
    sha256 cellar: :any, x86_64_linux:  "98fd1454d9118d5c353fdc9547ad0572eb0dbabf237c6e6b95b314d3a6c5144c"
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
    system ENV.cxx, "-std=c++14", "test.cpp", "-I#{include}", "-L#{lib}", "-larmadillo", "-o", "test"
    assert_equal version.to_s.to_i, shell_output("./test").to_i
  end
end
