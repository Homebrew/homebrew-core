class Bandicoot < Formula
  desc "C++ library for GPU accelerated linear algebra"
  homepage "https://coot.sourceforge.io/"
  url "https://gitlab.com/bandicoot-lib/bandicoot-code/-/archive/4.0.3/bandicoot-code-4.0.3.tar.bz2"
  sha256 "76913d2b1273b4f63f34e7e530ed0e69170f39f598ae472b8271ba1c75a3a7db"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1da75a50a5264145b76e139594cb1c6eb08b392ccbdc8b8244f64f6815e7289b"
    sha256 cellar: :any, arm64_sequoia: "be011ebe9cef13d2159fb1f87e13417e4a4e1f368efffcf06d3fff1ffd4daf51"
    sha256 cellar: :any, arm64_sonoma:  "2d89effd74a0c1e388c38fe505396c12e74a5c69529f6484cec51d8fd0156c31"
    sha256 cellar: :any, sonoma:        "f45affbd8373d28c7884298713c5abf17f3d670165b82b813e6a0e94f94bf4e4"
    sha256 cellar: :any, arm64_linux:   "0b03a42eca24973d80ee82ef5621e3e26f6beb1801ac569f9258c788f4d07b66"
    sha256 cellar: :any, x86_64_linux:  "850de6da4b08a4b9d56e5db3c53f43a5fec162870da21fc0910a5fad8ea7d979"
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
    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}", "-L#{lib}", "-lbandicoot", "-o", "test"

    # Check that the coot version matches with the formula version
    assert_equal version.to_s.to_i, shell_output("./test").to_i
  end
end
