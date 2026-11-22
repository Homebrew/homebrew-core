class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-15.8.0.tar.xz"
  sha256 "84cba6695fa523a7bf9d46bd20d000c4d4f108fbdc15ba45c294d507f5def880"
  license "Apache-2.0"
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    manifest_sha256 "f490b879599355054696a5b0542489fc3abc89fa949b7c819555e002c67dd391"
    sha256 cellar: :any, arm64_golden_gate: "8c498d9abbd41ec283841b81a21278a82f3be6629ed3f51e125b89deb0b404ec"
    sha256 cellar: :any, arm64_tahoe:       "2365840d78427e6b65a6007bb2b16886eb73746a76f9c1ceceb07bcda88ef87b"
    sha256 cellar: :any, arm64_sequoia:     "09ee08ae6547ab399669162bccbe0cc5c79f16164b3a5efebe88c824027517ca"
    sha256 cellar: :any, arm64_linux:       "59ba759bbc145fe099919e117ed63f8e74752407a741932ebd347043a39d9abe"
    sha256 cellar: :any, x86_64_linux:      "5425351e7dde11fe7502c6c56464b13a2bdb094791480b0373e69a93afe8f21f"
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
