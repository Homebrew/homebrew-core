class Bandicoot < Formula
  desc "C++ library for GPU accelerated linear algebra"
  homepage "https://coot.sourceforge.io/"
  url "https://gitlab.com/bandicoot-lib/bandicoot-code/-/archive/4.0.0/bandicoot-code-4.0.0.tar.bz2"
  sha256 "b4836bcb332e6d87c3fa4e1438bf6d8f6ab4c1d459db5b52c4260642fdbc7598"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c135aee940cff60836d85396cb67674f616606e7107d15ad84780d2b2c6dd207"
    sha256 cellar: :any,                 arm64_sequoia: "432c737123e9453dce95a5304e04a3875f64ae7bfaa9837dc21a01f2afa29b83"
    sha256 cellar: :any,                 arm64_sonoma:  "40154e36817bcbfdcc7ac5c23825fd2243f1f30d5209c7e389791beb59cdd6a7"
    sha256 cellar: :any,                 sonoma:        "c65e16e2a18237bb451051249a1bf4e2ecb2da68dd16b89f7697278bee2fe2cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee3cd7e28c7036510fb717974c02209e6b8328f0aa1cf373cfed1cf92e82a354"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ff7f8a5172dbf09a40fca89f9c822aced487d1abc5c244a52d418ba69554d8e"
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
