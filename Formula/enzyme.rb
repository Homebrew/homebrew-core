class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.61.tar.gz", using: :homebrew_curl
  sha256 "746322d6ef21a3518fe25a4a7b5e0ac027b9680f2e592b5871041d3460bf01f2"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7b2c63693c1a7009a522f3bc1477eb7197b737d9bde3ceaf8b3e2567e30504a3"
    sha256 cellar: :any,                 arm64_monterey: "554c11283716705441856204cf923dc13604b616815cdb07440147ae70b7f5dd"
    sha256 cellar: :any,                 arm64_big_sur:  "0d6a2a96e7815f7a426d5c729476a5e833f624e4175a4702b6386899c2fd1f8a"
    sha256 cellar: :any,                 ventura:        "e7eb06f6611e449b573342ce405c407d6041a1adb0d15a13a1be1ecf1f657b2f"
    sha256 cellar: :any,                 monterey:       "6cb6dfb61d3c5e4056fbb7a4b03aabc9c527a999c92b233361a35f9fa5c76661"
    sha256 cellar: :any,                 big_sur:        "0fe7087616333ddc0555f1ff1c3a09e688ecc8a0ec266774d30d05b6f653317b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "060a34b5c3b6eb0d08a8c71a3a74bf7cdb0c6b1e74f5d0755e2cc7665d6f53eb"
  end

  depends_on "cmake" => :build
  depends_on "llvm@15"

  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    system "cmake", "-S", "enzyme", "-B", "build", "-DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      extern double __enzyme_autodiff(void*, double);
      double square(double x) {
        return x * x;
      }
      double dsquare(double x) {
        return __enzyme_autodiff(square, x);
      }
      int main() {
        double i = 21.0;
        printf("square(%.0f)=%.0f, dsquare(%.0f)=%.0f\\n", i, square(i), i, dsquare(i));
      }
    EOS

    opt = llvm.opt_bin/"opt"
    ENV["CC"] = llvm.opt_bin/"clang"

    # `-Xclang -no-opaque-pointers` is a transitional flag for LLVM 15, and will
    # likely be need to removed in LLVM 16. See:
    # https://llvm.org/docs/OpaquePointers.html#version-support
    system ENV.cc, "-v", testpath/"test.c", "-S", "-emit-llvm", "-o", "input.ll", "-O2",
                   "-fno-vectorize", "-fno-slp-vectorize", "-fno-unroll-loops",
                   "-Xclang", "-no-opaque-pointers"
    system opt, "input.ll", "--enable-new-pm=0",
                "-load=#{opt_lib/shared_library("LLVMEnzyme-#{llvm.version.major}")}",
                "--enzyme-attributor=0", "-enzyme", "-o", "output.ll", "-S"
    system ENV.cc, "output.ll", "-O3", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output("./test")
  end
end
