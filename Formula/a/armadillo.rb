class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-15.2.4.tar.xz"
  sha256 "bb03a16da6b2cca43962b65a2890faf4e6b16607220cf60270436a11e09e6f46"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8e90fcc27881c4c0fd2fbdc18d40e7f0dd3d3e78f7e00e97afe88d1826bea7b3"
    sha256 cellar: :any,                 arm64_sequoia: "b59b82996fa2f7e515367298e89c2e8f766468fa59d12b418110f050d5f946e2"
    sha256 cellar: :any,                 arm64_sonoma:  "ff019baa3b8931954b1ff80a33726fe905c07374d5410749dcced8918ba34f08"
    sha256 cellar: :any,                 sonoma:        "b044572101ba8802a95f00a705ef1d78ae65233a2907502934799521f718d2a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5386633bf0ec3ed2ba7e99b556532507832983e1e35a143359a71fc8cce1fc9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a3f9de2cf0d522cc5e2cdc833d703f91c4dc774f51d94f29855225151afe6b5"
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
