class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-15.2.2.tar.xz"
  sha256 "8ee01cd4da55bc07b7bc7d3cba702ac6e8137d384d7e7185f3f4ae1f0c79704f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "64f7c7892781945c67692f516b8237125e1a8d822d72724284db8ffffa4ea22a"
    sha256 cellar: :any,                 arm64_sequoia: "3729b4736e360f0bd0ae72b527d595e672e115b11cd282a6131bcc8ea0dd83e6"
    sha256 cellar: :any,                 arm64_sonoma:  "3879558164ee91e4be6b368606e5e707d5636938528730a4bb1aefbf9b396112"
    sha256 cellar: :any,                 sonoma:        "5c00cd51324b0cd1a420589a35772eb64a898236deb0ca9f230f08ecc0cf9ed1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb40d53e25df89fae52dac2d4513557d8ebf666ffc52264f87debb78334807a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b6d53719e54dab8ff72978b779894597e7f9a0e486f18fc733a247051d02c0c"
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
