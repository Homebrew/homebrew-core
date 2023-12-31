class Bandicoot < Formula
  desc "C++ library for GPU accelerated linear algebra"
  homepage "https://coot.sourceforge.io/"
  url "https://gitlab.com/conradsnicta/bandicoot-code/-/archive/1.12.2/bandicoot-code-1.12.2.tar.bz2"
  sha256 "a72716138ecb1ffb4174d5192d0c9eb9106ba92aeb41c7033a8928ccbfa386df"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2ee8ca16edb2e0bc2971c533fab1fb9a3eba26cc47b65439b1d6a07a5f7c11c5"
    sha256 cellar: :any,                 arm64_monterey: "1fa012ec3c55e998918f241ec7d7fc927ec29262d35c7c38df0958c1cc1d63da"
    sha256 cellar: :any,                 sonoma:         "d9c479d10e565b53cc7ef542323b793c67beb348f92e5d5451538d412f33c4ce"
    sha256 cellar: :any,                 ventura:        "d5c0d8328d2769e7e3c3f883b0fc5d653dda2cc59b26c77cde31989e630524f4"
    sha256 cellar: :any,                 monterey:       "0b295acc094c675d62851f76e0d9a3bf3c44bcbdc17bed01a8753517061d7988"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "510b8108ff91e1c0fe1a5ae6e6ad78e9676c4732754f2d80207c0899f7bee82d"
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
