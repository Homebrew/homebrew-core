class Bandicoot < Formula
  desc "C++ library for GPU accelerated linear algebra"
  homepage "https://coot.sourceforge.io/"
  url "https://gitlab.com/bandicoot-lib/bandicoot-code/-/archive/1.16.2/bandicoot-code-1.16.2.tar.bz2"
  sha256 "ce248b3f163919ed85cb140124b2e16a6b4df11a9e9933d533ff12da219824aa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "de001a5385558fe001c2c6d506322c53b651162c9ae89d02f9319ba20a756c30"
    sha256 cellar: :any,                 arm64_sonoma:  "dc6e8827bfeb171211c2d746b3a96b1090d834fa0e6473b9ea51bc946d47bb81"
    sha256 cellar: :any,                 arm64_ventura: "e5ea4cbde255f6c9f0bc3d01a7b11c853dcb441bf927dca58961f50f15f11984"
    sha256 cellar: :any,                 sonoma:        "1db2036d7f853673161c668b5a0889b74e17dcbf1ccc5384a919a63a93ebb3dc"
    sha256 cellar: :any,                 ventura:       "f1a97297c4ba2488925a8039bea63092693f9223a4020a08b0782a6507a2b797"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59d673384fb931ce83416ebf576b7687267098dc491e0c6e005dd231c7d881e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98d8e185d883a12c7e442ea3df21c1c34f433534a50aa69b81218d5f437f83fa"
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
