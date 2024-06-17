class Bandicoot < Formula
  desc "C++ library for GPU accelerated linear algebra"
  homepage "https://coot.sourceforge.io/"
  url "https://gitlab.com/bandicoot-lib/bandicoot-code/-/archive/1.14.0/bandicoot-code-1.14.0.tar.bz2"
  sha256 "153282f5c62332a26054c0b2371c5a239f4c9461344d7f8d6df555da5b43a698"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b6a761dca77563e2994ecac6b2b272c669c69cfa9a6c7294793624c1c8882842"
    sha256 cellar: :any,                 arm64_ventura:  "85500f08c4e6c1d8bcc89bf301a06c80189c03fb831840efde0ceef4a8d3c625"
    sha256 cellar: :any,                 arm64_monterey: "1034e63fb070ffd89844e33c6f9b9f1c04a389fc6a5cfc4d515af76bc6b3297a"
    sha256 cellar: :any,                 sonoma:         "e7c19f0f248b357b79f3ded34e07fd97310345bfe1ff2c6ade2f28c042176a86"
    sha256 cellar: :any,                 ventura:        "79ab823b21a6b933a63d423e859585c4912f8e939ee970d061d9a9818dbb3d7e"
    sha256 cellar: :any,                 monterey:       "352fb5431c2efe702f70106fdac2c5504c52c2b72ba2e1d0288c69327d5adab3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c75200dcb9f52926e7e232800095d27d38ceb1cf54eab023375cbd34140faf1e"
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
