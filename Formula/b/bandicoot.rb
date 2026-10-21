class Bandicoot < Formula
  desc "C++ library for GPU accelerated linear algebra"
  homepage "https://coot.sourceforge.io/"
  url "https://gitlab.com/bandicoot-lib/bandicoot-code/-/archive/5.0.0/bandicoot-code-5.0.0.tar.bz2"
  sha256 "875f64e13d370d9659a719a389ada4bbc1cd2caa38c68d52087c9a8ff88ef64f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e18cf9df7ff19d6d5c9c6767d0d2da7995e093937de599ff0cd68c28dda4f098"
    sha256 cellar: :any, arm64_tahoe:       "70f4d0a11902993cc8c60b6803e7fe2b7ad6d7db0276d829e5b4a7159669f7aa"
    sha256 cellar: :any, arm64_sequoia:     "1d26a369ed78009eb64ccbeb4727c76acf2d259cc539737ea3dff85571d640f6"
    sha256 cellar: :any, arm64_linux:       "f785fa3b76b4fe032148e8e4767d0162f43bf306431ddc5764d03875c368194c"
    sha256 cellar: :any, x86_64_linux:      "529afe730af85f611cdf55c491d135291c507247aafc7d9f5eafbb289f6a616f"
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

  deny_network_access!

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
    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}", "-L#{lib}", "-lbandicoot", "-o", "test"

    # Check that the coot version matches with the formula version
    assert_equal version.to_s.to_i, shell_output("./test").to_i
  end
end
