class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-15.4.1.tar.xz"
  sha256 "12781baf33c71b622c2f040fd27143479d120ec89d40f889621f0b1bb6232e27"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e94f30d7b4c0dd8f0395d1192bf2e10d2d2710a576deed2d644068af680d2b4f"
    sha256 cellar: :any, arm64_sequoia: "43b4870b1e97f6d894feb21a17c7be09b562cab5f767258337089c9bd7e72a21"
    sha256 cellar: :any, arm64_sonoma:  "9e65d16a4b9c3d0fd8e5db385d548ff3053747aef1ef46f1ec3812b7bad7c2e1"
    sha256 cellar: :any, sonoma:        "ef923b8281da8a19af10f94c3688b081cc814c0fb2da9e7f6fb73eb8e400fb7b"
    sha256 cellar: :any, arm64_linux:   "8131ce278d92067fd393bba7c6507dfa3970f5dbb0195bfb6cbebbbee75dac69"
    sha256 cellar: :any, x86_64_linux:  "36a05ff9114b781dac6ec92bfc5711c9753c6bd6d3d96daf002903ee69883fa9"
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
