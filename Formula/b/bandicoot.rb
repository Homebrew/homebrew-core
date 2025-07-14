class Bandicoot < Formula
  desc "C++ library for GPU accelerated linear algebra"
  homepage "https://coot.sourceforge.io/"
  url "https://gitlab.com/bandicoot-lib/bandicoot-code/-/archive/2.1.1/bandicoot-code-2.1.1.tar.bz2"
  sha256 "128a02062426fbb88aaf6a00af227ee9d40e083e4c78fa560498ff06ae381544"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9eca2fb6a06c29cebd5fd25ddf5878ae34d88d5b923fa1fed5aed1a9e0773c98"
    sha256 cellar: :any,                 arm64_sonoma:  "b55ec22827391201012634b5ae8e634c8e78cd254c15230b697ea3374cf46bb5"
    sha256 cellar: :any,                 arm64_ventura: "9831c4eea08c9dc12470f68591f42f310998b6ee4ab5d362be142cb3e7514c7e"
    sha256 cellar: :any,                 sonoma:        "2ab39c81ba1c29f3cbc6ece50efecba6235c8f6d1f8c888e2aad80f25e3890b7"
    sha256 cellar: :any,                 ventura:       "b2c5cf47375d80f86139639924fa492acdcb7768f1e7f8b33b0f8cdce219834f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "757d99751200c72d5b79d7f90be7e0faed3a23501f62af28156c9c66512d94d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "252019c9e01386f84034a00808cd5c9cd7c03c24d26818b855ee1ad85452c10e"
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
