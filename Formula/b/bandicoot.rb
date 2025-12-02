class Bandicoot < Formula
  desc "C++ library for GPU accelerated linear algebra"
  homepage "https://coot.sourceforge.io/"
  url "https://gitlab.com/bandicoot-lib/bandicoot-code/-/archive/3.0.1/bandicoot-code-3.0.1.tar.bz2"
  sha256 "c3a1977d162d7f678df79c8305344e7c1768fdf5b5441f33f6b4a02d90b64300"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c394ea05212c1ea41029110aa67a4a4318071abad3cee50e334a5d1d8252a06a"
    sha256 cellar: :any,                 arm64_sequoia: "920375ad5ecdfa143d76a3cd35377d5c218b82fc8bdb963f20a635a618164070"
    sha256 cellar: :any,                 arm64_sonoma:  "8fe8e9a54aedef6401ed1032f39af4fb825d8caee3e1168aec12b0684e97f523"
    sha256 cellar: :any,                 sonoma:        "122f673684a564480a6710a2d8a3156f4bb61a0d1f966d12334dfd6f87b97746"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6328ae4e2f7fbc9094c0261851e61b520e75e60896df25c855c7e0bb028dd7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f45369341b609c7405a0a1a3bea3783e502a4fa666db26a07a7e7f1b407cde0"
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
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{lib}", "-lbandicoot", "-o", "test"

    # Check that the coot version matches with the formula version
    assert_equal version.to_s.to_i, shell_output("./test").to_i
  end
end
