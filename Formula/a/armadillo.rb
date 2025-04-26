class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-14.4.2.tar.xz"
  sha256 "6dfddcfbd91e70679d7c11e94a5963a7efda002fec351e6f4875ac8e245c5117"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5a4c62a61f6c9ebf9d6df1aed9299c9ac496f67d22fa801021580a98f18a757f"
    sha256 cellar: :any,                 arm64_sonoma:  "12abd91318b767e5b3f06a086a7fa5bd0ebb8627382b6783cd750be987239175"
    sha256 cellar: :any,                 arm64_ventura: "ee00d2190e28f52f572645cd698bff73690f44a05d124610f53c3b4c0fe9a201"
    sha256 cellar: :any,                 sonoma:        "fce7394c80252b4026300a498090df74c31c166907fcfa0d99ac6e36f90ee991"
    sha256 cellar: :any,                 ventura:       "79a8e27963c3123e2fde50be489263b6222eff42b930e68238857b824d8116a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9253e78f3ac7ef9e5a21c33857cfd1ba3ec1e6c18826da5a12947eec3074da63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "635b61051983a0c1dfb3e4463c4ba34f511ee5ca35638531c5845f0514c55cec"
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
