class Bandicoot < Formula
  desc "C++ library for GPU accelerated linear algebra"
  homepage "https://coot.sourceforge.io/"
  url "https://gitlab.com/bandicoot-lib/bandicoot-code/-/archive/1.16.1/bandicoot-code-1.16.1.tar.bz2"
  sha256 "b9c6532b8c7e37dd7986ccd346a849db57cca4024ce41c3591f778139531b1d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d3e5cae271211ff164554d8c9f065d4a6707a08f8c20e26f1409f1e506ef01b8"
    sha256 cellar: :any,                 arm64_sonoma:  "dcbb689ef19632d7e26ef7d17242e0357debda872cc350795ae2d8b4e0f5679a"
    sha256 cellar: :any,                 arm64_ventura: "aa9bef5d8e8454bb791209fb94916c114003a6a0890bd666fd64e6fabb1edd63"
    sha256 cellar: :any,                 sonoma:        "83c3169b28393ac1ee07224951d2e072f4cf8d972419507739036f4e2f095586"
    sha256 cellar: :any,                 ventura:       "58798b5f55aac745c9aff6b7d0ab32b4ec19597673fdf62bc0a84992ccceab6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f442ff6aaafcb1376fbf3257a5355ff369734d09f0a7b7e8218ea94dfce29a18"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "clblas"
  depends_on "openblas"

  # Ensure CL components are present on Linux
  on_linux do
    depends_on "opencl-headers" => [:build, :test]
    depends_on "opencl-icd-loader"
    depends_on "pocl"
  end

  def install
    args = []
    # Enable the detection of OpenBLAS on macOS. Avoid specifying detection for linux
    args += ["-DALLOW_OPENBLAS_MACOS=ON", "-DALLOW_BLAS_LAPACK_MACOS=ON"] if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Create a test script that compiles a program
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <bandicoot>

      int main(int argc, char** argv) {
        std::cout << coot::coot_version::as_string() << std::endl;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{lib}", "-lbandicoot", "-o", "test"

    # Check that the coot version matches with the formula version
    assert_equal version.to_s.to_i, shell_output("./test").to_i
  end
end
