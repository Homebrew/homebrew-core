class Bandicoot < Formula
  desc "C++ library for GPU accelerated linear algebra"
  homepage "https://coot.sourceforge.io/"
  url "https://gitlab.com/conradsnicta/bandicoot-code/-/archive/1.12.3/bandicoot-code-1.12.3.tar.bz2"
  sha256 "55c650a25e6ff59c02f3de2290971de14e69949e7982ee54db4eaede38123ae6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ada65d8561827731620152a273f5153603acf8505b51689f33699e54323d1280"
    sha256 cellar: :any,                 arm64_ventura:  "016ef2e849e14a633585bc34145c9943cbd75884ca7c18934824dde6db7a740f"
    sha256 cellar: :any,                 arm64_monterey: "59b54498677bff5e4ef42377b19ebe2bdc1b3f73af912a7f1c050fc455800b72"
    sha256 cellar: :any,                 sonoma:         "dc251224481dfba3473552404a9a1539a67017ae507847e5b503dbb00add2089"
    sha256 cellar: :any,                 ventura:        "a0d1e1263b7c36d1d05b6a085e5055ba108b70bb2596174d1c05f91ec3755e18"
    sha256 cellar: :any,                 monterey:       "dcee624badab8de9caeedcaf3dadc14773c8ab53349e411cb02d6f81888021c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5dcd6387f029529ff3e5ecc2ac972fd89cf981acc706a3b8b1dd6552d8059eb"
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
