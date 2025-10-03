class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-15.0.3.tar.xz"
  sha256 "9f55ec10f0a91fb6479ab4ed2b37a52445aee917706a238d170b5220c022fe43"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c79310a9cc9f8381303054401bbb5d4c3e0ba7364b2c77fec423a011f4f6a56a"
    sha256 cellar: :any,                 arm64_sequoia: "187d141126b6c4c4f659e92200d7a281959d71ee3f9ba731bfe35a7c62bdc265"
    sha256 cellar: :any,                 arm64_sonoma:  "292da348dc5691ce8781d66f655783112f433ef533e103a40312d36fa6c54856"
    sha256 cellar: :any,                 sonoma:        "e4bf0f1959358dd497cbf935ab1b1aa197fcdd20f71cdb37c9bfb765e28b134a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95d82f0bebeac2e0e3074922df03e1b19a3df834059c7d7c9e3585a9ba57bf3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af3735908dfcbc1486ba740d2fd07cdcbdd4555c1e11d18bd822f65138becdfc"
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
