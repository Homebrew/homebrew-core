class Bandicoot < Formula
  desc "C++ library for GPU accelerated linear algebra"
  homepage "https://coot.sourceforge.io/"
  url "https://gitlab.com/bandicoot-lib/bandicoot-code/-/archive/2.0.0/bandicoot-code-2.0.0.tar.bz2"
  sha256 "30d6a1d45d470808db231ca7f3cb0c17aa87da2439cb66517e92f48ca70967a3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "db31e5f666f4b6cdc012bb7fdfe0ac544b787e4fcefea84d30ffde1a49a13c3c"
    sha256 cellar: :any,                 arm64_sonoma:  "62afce76eb43d865812f70284f409e1fe2720cd18489107a17eab5ed45f9aa15"
    sha256 cellar: :any,                 arm64_ventura: "343c601cd3268dcc3af31aa5568c39da5167f23b7cf8f212ff037116fe26fd6a"
    sha256 cellar: :any,                 sonoma:        "60bbf041aafc60a7c67c0bc717022e9153f4a0325093dcc1e1a15400bfe89841"
    sha256 cellar: :any,                 ventura:       "ffc82a05e033e6563733b245938a37a55db196c8e3c499b8d6387277021a584d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5060606c7d1b5314c2abf8581fee37550172323cfbce2da9ebe2f60afc771bd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a036a413f7ffa0e5e2187efda03dc64514d4dccb302ef1e562c47f0d10d3aabb"
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
