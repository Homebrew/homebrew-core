class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  # upstream issue report, https://github.com/EnzymeAD/Enzyme/issues/1480
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.88.tar.gz", using: :homebrew_curl
  sha256 "723cf72edcd4e7d60219ecadcb9a2fb90837298aaa79bee121b2c6d989892357"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dbc7c736124ab489dc0e88f022ea7ca3425fa1f8d100785a68b1c433d7e4d6b5"
    sha256 cellar: :any,                 arm64_ventura:  "691e1188677b44346a0d19f9aa9c6f8393b3157c5c3ab6235ce17d1b741bb69b"
    sha256 cellar: :any,                 arm64_monterey: "c6ba82e90925c857c4e999eb33ec6c6320230aac3b35e2aa3c45eb1be7171951"
    sha256 cellar: :any,                 sonoma:         "126ea6830a98e65e4e41ec92909d04ce703a5df517beb8bd753193cf4f7e7e47"
    sha256 cellar: :any,                 ventura:        "a0854568fdad888971ed3b933aa3fa89d27432fcfd2b53d21ed38bfda63e3d70"
    sha256 cellar: :any,                 monterey:       "85de3ed5d62a90d6825fc22c6936fde476c5ae69266d775f7845e7fe8a3e38bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2377d1521f0caaa0c591a60fd7d4f1f26a5a85133dc0627aba58e5b71965830e"
  end

  depends_on "cmake" => :build
  depends_on "llvm@16"

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
