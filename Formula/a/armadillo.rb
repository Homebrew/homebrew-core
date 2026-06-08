class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-15.2.7.tar.xz"
  sha256 "029230b29c3745924ea850c7046efd1db74b863fdfead8b1aaba3bdd5b0cf895"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3bf461d2e1c3f871151adea14290795d3772b51fdb472bcce0d5a28db5e20494"
    sha256 cellar: :any,                 arm64_sequoia: "fa243a17e7dc7786563d29d142fe2258f15e74db6fb7a1159248160d0235b563"
    sha256 cellar: :any,                 arm64_sonoma:  "ce20dc94f641e91c0e0d3951b3938cbcc93159a79582c9b88c96655a678bbc3a"
    sha256 cellar: :any,                 sonoma:        "1942b85b5a9bb57c842280023c4a46fdab45d2a057c3a93faeed31530c82c7f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "213fb3fe2a512e0a894fd5182fe79388b69b8a3134f10c2587a97462f83d5340"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20bd7792af4f42eaa0b844b193cf6f0dee966b11b0cbe5ee1cfad56c4bf3ac51"
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
