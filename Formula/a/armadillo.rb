class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-15.6.0.tar.xz"
  sha256 "e00a11b15ce4f3a75c634bfa58411ce1acb4317705b418a72348e81dc8f56464"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b07cf3fcb50d2af52e0d21809ef5c4028ab272568f528f2256ec2a0e128a6c8f"
    sha256 cellar: :any, arm64_tahoe:       "61b5c3ea056fdb0124a593dcba74b84638755e5742dffeadc03c45e315ecd229"
    sha256 cellar: :any, arm64_sequoia:     "99f2a571210ec7f7e90e4aedab8d8706194fbe1d88d29272336051d49ce9ff15"
    sha256 cellar: :any, arm64_sonoma:      "c1aa3611d5edad35932d8b6bb76563d30846fec60a2d8e59614f6efa03db2743"
    sha256 cellar: :any, arm64_linux:       "669e073d3e6d2903d1f680a382d6d3c4a7ffea1c70a29ab3553309b601b51de4"
    sha256 cellar: :any, x86_64_linux:      "7bdb417cfe61fd4deaa8b6e5cc3babc315e12da7ffbba2c3001f529b308be0af"
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
