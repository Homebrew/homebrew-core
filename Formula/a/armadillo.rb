class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-15.0.2.tar.xz"
  sha256 "990ab4ccb7eff1b6d70409e9aa7fa4119877ac5f5d10ba219e98460ab3e4d6eb"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "09f291a21b01f4d50c1746e3b06ecd422fbb2f476b2405d00ee835fa7c629858"
    sha256 cellar: :any,                 arm64_sequoia: "b80c95891c2c6eb8eece24e86792e2fa439245c09c88eca540a5260007fb349e"
    sha256 cellar: :any,                 arm64_sonoma:  "b2bbb56abe7ec6639710be4514c7c277d43c142203a5291b6f80f9ec43bc311c"
    sha256 cellar: :any,                 arm64_ventura: "281a018050fd7e158b7deba13affe6c007c91970d432c8f5c2a68eb4ac76d44d"
    sha256 cellar: :any,                 sonoma:        "8bf5dfa5d1e0f9b6f14156b19a273119766a79d74e71e314b15b4c04fdc679e5"
    sha256 cellar: :any,                 ventura:       "9253e6a0a87b28e5779cc8baa4ad623dbe7bf9e4956f37df083e00b4a0f30beb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "729bb4003932a5d5b17823fdbff63dbd45f0f243e14ac25a374d79f2277cb842"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43468b47c894f392be50c47d6caeb0af431e1991bacbcaed9608ca5ac9eee800"
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
