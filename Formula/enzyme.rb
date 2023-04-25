class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.57.tar.gz", using: :homebrew_curl
  sha256 "6ef636838e50422f771c19e33e832a4f9ac72e99d90c855569a5b949e3df24a9"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8654fbfb71283541f4aae3e314c59c1cffe028bd79b4b570dd7f8f7a941e7b0d"
    sha256 cellar: :any,                 arm64_monterey: "9ac6fb114df15c9502096cbb6c8005bc7b9e171fd6a0c2c52fefb73f217d8498"
    sha256 cellar: :any,                 arm64_big_sur:  "5181add0cd4ca5af01742ecc300e1261bb1341be5d6cda8ce4ee8fdab067c5a1"
    sha256 cellar: :any,                 ventura:        "aa1c1a0c30305b426882ca81545e44bd12b08122778f3cb4da788d9502f2db82"
    sha256 cellar: :any,                 monterey:       "094ebcfbb3dcc60767eb3d244d1a85eef01564893367e81f4c5fc1ef3c157e07"
    sha256 cellar: :any,                 big_sur:        "2243609bb956a3a2520ed0f641f017a568672ccaee68c0a64663d90d0c4e82dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63f962fb9bf3490c59e5624706fffc44a65c75c73a3dfc5876cbc77fda8b82a6"
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
