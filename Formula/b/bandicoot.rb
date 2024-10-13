class Bandicoot < Formula
  desc "C++ library for GPU accelerated linear algebra"
  homepage "https://coot.sourceforge.io/"
  url "https://gitlab.com/bandicoot-lib/bandicoot-code/-/archive/1.15.0/bandicoot-code-1.15.0.tar.bz2"
  sha256 "cfe935a8eb23ae03e9db9f817040268b5d9e8d4a370c792f0476438379bf7b96"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "3ac4edc2d604981788ac093d8577689a6ef9c2544eb94dcc7f5913172934da6c"
    sha256 cellar: :any,                 arm64_sonoma:   "514515d6a43c9cabb86877d0a0f94983dfcd8ffbec74cb282406c79da5e0068f"
    sha256 cellar: :any,                 arm64_ventura:  "713cae9be9a4bd2124224dcb7d2618e940d80d56361bc31b596caa73cb2f0c40"
    sha256 cellar: :any,                 arm64_monterey: "2c389b73c8ac099b14432861726285d68789d1a626a12f550a45c121df2287a8"
    sha256 cellar: :any,                 sonoma:         "70c6cdf08f6a1702545a7d4a3e8fa0220672c5c6da54b12124b7941d5a42b42e"
    sha256 cellar: :any,                 ventura:        "79871e12ffc4d1c6b0e38ee40c8a4feb73adae00d558eb6cb7ffe43a54a7c196"
    sha256 cellar: :any,                 monterey:       "918e5c4b75156d156e0acac3dda3fc7569c8596a68908f93dbb040176dda0c93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d609502f3a22751f9aa62a026789ac3bb7157702945f84d5f269f69cbf0b8136"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "clblas"
  depends_on "openblas"

  # Ensure CL components are present on Linux
  on_linux do
    depends_on "opencl-headers" => [:build, :test]
    depends_on "opencl-icd-loader"
    depends_on "pocl"
  end

  def install
    if OS.mac?
      # Enable the detection of OpenBLAS on macOS
      system "cmake", "-S", ".", "-B", "build",
                      "-DALLOW_OPENBLAS_MACOS=ON",
                      "-DALLOW_BLAS_LAPACK_MACOS=ON",
                      *std_cmake_args
    else
      # Avoid specifying detection for linux
      system "cmake", "-S", ".", "-B", "build",
                      *std_cmake_args
    end
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Create a test script that compiles a program
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <bandicoot>

      int main(int argc, char** argv) {
        std::cout << coot::coot_version::as_string() << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{lib}", "-lbandicoot", "-o", "test"

    # Check that the coot version matches with the formula version
    assert_equal shell_output("./test").to_i, version.to_s.to_i
  end
end
