class Bandicoot < Formula
  desc "C++ library for GPU accelerated linear algebra"
  homepage "https://coot.sourceforge.io/"
  url "https://gitlab.com/conradsnicta/bandicoot-code/-/archive/1.11.0/bandicoot-code-1.11.0.tar.bz2"
  sha256 "e53fa0db2cd890475ad41452b0a70b036315e32dcbe45687f149789e341a85f6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a7fe2789a120b069cdf356e97f48e83ace1a27cca513fe75ea298218566f3343"
    sha256 cellar: :any,                 arm64_monterey: "fbce0613203005d485e5903eddcbb0a65af5cb3465f4a0954a1cfe0ba097c91c"
    sha256 cellar: :any,                 sonoma:         "e0e92e27c8eab643de8ace1a4dfbb76a25c5d875bffdd7b5e2fed5818eb0f47f"
    sha256 cellar: :any,                 ventura:        "e9d073a3f19b5bb9c733d18edd2df0b2a0a28ce08f76f47b6c96d45d0110a236"
    sha256 cellar: :any,                 monterey:       "184a6f22baf4c5d19704e3b0a15e7e6b1921810fd8edd008aa5e96ef4c4ec767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0af67180b4874f79cff2c316db4ed782032b9ecaeebdc1acee3d0462ac46e424"
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
