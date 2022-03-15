class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/v0.0.28.tar.gz", using: :homebrew_curl
  sha256 "59f63b757326cda23a0f879ccb7ca18d4b2c276ef3d2055f6ec8818657671475"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "421f4e2c0084c396f713a3a90dc27aac4cd0af8c6f267943a20a622e9ef5c353"
    sha256 cellar: :any,                 arm64_big_sur:  "3d96f98e3b36bd7843b28f42a315d3ead4e38d2250e483d3604367a13fb34320"
    sha256 cellar: :any,                 monterey:       "530e16b278c9f90f5a44e8832b18ca914fa40e7b12bbaf08733f8169435fdd54"
    sha256 cellar: :any,                 big_sur:        "447ac8d7938d97e28686c8f04aea88526b98e9c839df5a6c93515abf98f8c48e"
    sha256 cellar: :any,                 catalina:       "a86906ef479ef3b0c2b5c702941262ce195691bdc3dce9f3c913b6fe999d5066"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68daddbd437d615eacd0044733fbbe581c9f09f4345a6bc58b6fc67e555c0a4f"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  on_linux do
    depends_on "gcc" => :build
  end

  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match? "^llvm" }
  end

  def install
    system "cmake", "-S", "enzyme", "-B", "build", *std_cmake_args, "-DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm"
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

    system ENV.cc, testpath/"test.c", "-S", "-emit-llvm", "-o", "input.ll", "-O2",
                   "-fno-vectorize", "-fno-slp-vectorize", "-fno-unroll-loops"
    system opt, "input.ll", "--enable-new-pm=0",
                "-load=#{opt_lib/shared_library("LLVMEnzyme-#{llvm.version.major}")}",
                "--enzyme-attributor=0", "-enzyme", "-o", "output.ll", "-S"
    system ENV.cc, "output.ll", "-O3", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output("./test")
  end
end
