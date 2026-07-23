class Bandicoot < Formula
  desc "C++ library for GPU accelerated linear algebra"
  homepage "https://coot.sourceforge.io/"
  url "https://gitlab.com/bandicoot-lib/bandicoot-code/-/archive/4.0.2/bandicoot-code-4.0.2.tar.bz2"
  sha256 "ed88a156b057f04f81fea61ed19e60d0ab5a4f074d308bfd0c2b2d9f24a71f06"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c54a8bd013a7fccc386224d1ee17bf3af76e925f0272fca6a869dee43e23e134"
    sha256 cellar: :any, arm64_sequoia: "3a39a6df50f1c2a86a69710c89bf70c598bd21161586be7a373d3be83304e96f"
    sha256 cellar: :any, arm64_sonoma:  "31eb2ca0700a41d04e63b0101a81904ae064fa8c0e8ffe29aad0482fff149469"
    sha256 cellar: :any, sonoma:        "b07c3a03a65a925617ad995a03e84834eb7ed8955c306b0944279443d6f2d858"
    sha256 cellar: :any, arm64_linux:   "2014ca518e9a639d857f167ec23a98396a5ea2ed3e57b5d148d37f28ef8ec681"
    sha256 cellar: :any, x86_64_linux:  "ac09eec955b4340cf5824e44371fef46532a79245e3cc0b9c8990b2f1ee9b083"
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
