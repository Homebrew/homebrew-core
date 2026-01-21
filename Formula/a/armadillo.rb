class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-15.2.3.tar.xz"
  sha256 "0182d67d6949e4347a0bc62fc8c2793be7eb203c71f19edff93f8c45fd4a8190"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "82824c58423b415581cf335b4952215f439d3e7296afefa520103a2954ec7488"
    sha256 cellar: :any,                 arm64_sequoia: "5e6fc886aea60a0ac99c9b326fce8b3f254163bc3c74a34b855355330aca876d"
    sha256 cellar: :any,                 arm64_sonoma:  "10128a2e62d28bca4ad9d309653ae5219d5b2a458e48f54f9a0d64251588dc85"
    sha256 cellar: :any,                 sonoma:        "064c667e95a2b5fbbc2ba4a1e744d0cc856eb9908ffe10b6455d116331ed3c3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d64e165127c465c0ed55b6161e8f854a00e5a6468d36d8e379047a3d181a9d46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b925790e5c7cf547e0d20c4d2787771ad6f0b8a1d6b783485ebf999819a54853"
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
