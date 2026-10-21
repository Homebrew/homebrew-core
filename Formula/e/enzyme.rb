class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.303.tar.gz"
  sha256 "0ca3114d008e524cd3b13152bbc172794b20af643d1628161655373eba4554de"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7b1b7444c529972b840fc5104041f3685f478ad77dd4ddd0c12428e82c355bbb"
    sha256 cellar: :any, arm64_tahoe:       "c1dabb507bd76db3defaeefedb0a4b3f2355704d3fcf18f96af7f784cb0c0642"
    sha256 cellar: :any, arm64_sequoia:     "96466826a44623c760c5dfd090187d2d5b22ccfa181b84770183c659812aa843"
    sha256 cellar: :any, arm64_linux:       "1a0a8054d83b3282683f26989f3180264aab42d02d692a1c06aef3eadef4fda5"
    sha256 cellar: :any, x86_64_linux:      "1957e0ccbf1ff517e4afe236c5d99ac8aa9682c035c86d2be6b87e22ce612dfa"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  deny_network_access!

  def install
    system "cmake", "-S", "enzyme", "-B", "build", "-DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
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
        printf("square(%.0f)=%.0f, dsquare(%.0f)=%.0f", i, square(i), i, dsquare(i));
      }
    C

    ENV["CC"] = llvm.opt_bin/"clang"

    plugin = lib/shared_library("ClangEnzyme-#{llvm.version.major}")
    system ENV.cc, "test.c", "-fplugin=#{plugin}", "-O1", "-o", "test"
    assert_equal "square(21)=441, dsquare(21)=42", shell_output("./test")
  end
end
