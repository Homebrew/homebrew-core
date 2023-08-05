class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.79.tar.gz", using: :homebrew_curl
  sha256 "35db74728fc4dee1fab72dd7bb5575872fa17b01959bbdd07ebf18092611d851"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "27d7e56f57cb91395e1de4e4e9d9f946cd96fbce1f15b4db644536b2ab04c131"
    sha256 cellar: :any,                 arm64_monterey: "01ad76f7381ed484e27a8a657aa2c872544ea3cd0ae48de185773779ed835ec6"
    sha256 cellar: :any,                 arm64_big_sur:  "fa1989c6b0b2b71666c2574210f8d3ea950b3aeb9cda8dc5e3953cfd82bd42cf"
    sha256 cellar: :any,                 ventura:        "4eae4bb027e6191d65af931d5bb9cd0990ddd4405e06b2e0aa9274cef4fc71ef"
    sha256 cellar: :any,                 monterey:       "8eca6f49b29721e96f7b60e0bc5c0271067d3de8bf5c1af22963bc990bb9668d"
    sha256 cellar: :any,                 big_sur:        "1383be83528f1dac4c702af9fcc091048018df32c2d7eb5a1296d5372b2883fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97599110d93cb0c138a3c2b3c32c3dc57f84273b0768e680b9056bf372f750ac"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

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
