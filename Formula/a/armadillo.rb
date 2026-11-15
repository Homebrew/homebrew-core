class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-15.6.2.tar.xz"
  sha256 "63ee9351b54994dff7b4e2094a86ace48cfb41354cb65893a9dab7c8a16382c4"
  license "Apache-2.0"
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e49c9dfe1b4512bc4c33e20b6f426ab5a6efea5b921021c58c0c31b64062edb6"
    sha256 cellar: :any, arm64_tahoe:       "1b62c8794c7993476e280a741ab364eaeab112f0b52f16ab6b05139fdc6ddc2c"
    sha256 cellar: :any, arm64_sequoia:     "e64c256cdd4a85cd3a46b6e20ca7ccaac78aca6a95959f6ef77b3f2d55439297"
    sha256 cellar: :any, arm64_linux:       "74c88631fc8584b8ae1a8f545bf60eac042f4bde043c2d7f3f9c17fb448525f4"
    sha256 cellar: :any, x86_64_linux:      "d74790f076a9b9a2c8bb323f56f9605b807c7ba6b67c504af3616e2ac0a70db2"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "arpack"
  depends_on "openblas"

  deny_network_access!

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
