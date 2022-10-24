class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/v0.0.44.tar.gz", using: :homebrew_curl
  sha256 "f79edfa56d9355d815011606d93e74b1fb128f2a4cffbc408d8b629763e70ac0"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c23bab0159a7bbbb245163df046f5086598923a09f8f93c9a4d6b9b978ae678a"
    sha256 cellar: :any,                 arm64_big_sur:  "b2acd9b0d0a01f5dfcc040e3dc732b216f1fa566b09a28d2a2b5eb90f79ff73e"
    sha256 cellar: :any,                 monterey:       "10cd70c1ee87a6d00a9f75cfd04af969cae0bbbd1eb5406df3f243dee0e1a36d"
    sha256 cellar: :any,                 big_sur:        "c6a52ed1a63e5e3c3b11a23e75588417c0b98fe331379adf34626e91ebe51a38"
    sha256 cellar: :any,                 catalina:       "0263ec7f9c2d4b950a8b094e168501dcbe6f147c3be2c5f04afe5ece91dcfef6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "127e81d64bd0d3d1aed5d77065921aa21a48fafb892b56203d5ae98768118cbd"
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
