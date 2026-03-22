class Bandicoot < Formula
  desc "C++ library for GPU accelerated linear algebra"
  homepage "https://coot.sourceforge.io/"
  url "https://gitlab.com/bandicoot-lib/bandicoot-code/-/archive/3.1.0/bandicoot-code-3.1.0.tar.bz2"
  sha256 "27c8c6d36e6bbc64f4de0cfde89221f6d80a7d59de08c47666afeeacc806d1a5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5d67e6aed2699f62ee9f37b3bd2228349b82b826c6ccce2cff52ab5be84c3b2b"
    sha256 cellar: :any,                 arm64_sequoia: "98187deca3fd6cbed9bd4ad68fc48e05198e3c78aa5cd7166e14b0b538aee923"
    sha256 cellar: :any,                 arm64_sonoma:  "d6f10f687b2d75a0b5a832e2cd8b5b507aa8d5d75c3e2fe5e3d99945b656e86f"
    sha256 cellar: :any,                 sonoma:        "74c3eb05ae46f65f349e278a1ba74f39a301f66ddcc8d61e94efef7f91e220ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbbe98b28fa63bc236bd1cf7ccfb644e2f047a9863d41d2cc1070af4b0e152cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e30826e78801be597bb8e6c8a7da8c0f468ee427c7942ac373e4596ab0372ff"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "clblast"
  depends_on "openblas"

  # Ensure CL components are present on Linux
  on_linux do
    depends_on "opencl-headers" => [:build, :test]
    depends_on "opencl-icd-loader"
    depends_on "pocl"
  end

  def install
    args = ["-DFIND_CUDA=false"]
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
