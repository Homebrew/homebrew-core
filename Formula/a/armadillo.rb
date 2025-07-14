class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-14.6.0.tar.xz"
  sha256 "d18ccdb78a5da88f18fc529d8a8d40fad455842be6b01c59796f47a6f5bc7fe5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3450487d0ae28ced228259b22fe0800f19047c5d5af65fef4ca3a92880fe1a4e"
    sha256 cellar: :any,                 arm64_sonoma:  "dc0c39f63567bfdd61ecf6e1f2f827fa5a2ab1c448a0b7a8a153e5fd1bc95bf9"
    sha256 cellar: :any,                 arm64_ventura: "bbab80b9951fc46b094beb7c1292767f0bd62eb39b3714cf1df2cffea5ddc264"
    sha256 cellar: :any,                 sonoma:        "d3f75232d15fa6993062f409378fdb20bdb2a7b26fa082fb6e2b94f5b4627870"
    sha256 cellar: :any,                 ventura:       "9a011fbcf1efb50acccc1f68ade5668b3ad9907121db43da4def4048f8ab4e9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ceb7c0905ae991afb9bcaf890e6c67e007d4d480256fe7e160d2d4f669e48e6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5aa348c8c91f3f204e35a64387084794da130923607516841b213797346a7ffa"
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
