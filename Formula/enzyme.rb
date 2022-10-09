class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/v0.0.42.tar.gz", using: :homebrew_curl
  sha256 "a0ad5ab043180db8e689c30931f13977d3331d4719733854d053b94e223b7a6a"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b6d6d2e5084412c10fb5a19864d18e2cfc891fd702b1244c99838c703dc3106b"
    sha256 cellar: :any,                 arm64_big_sur:  "dc2cbe9be01da032640baf205c5860087be60cd9a1c942a69a721a0388149bef"
    sha256 cellar: :any,                 monterey:       "5358e0e3b2aed58abde9d2a3b4aa52056acd29bf15fd9bf05de8353b50bef2b2"
    sha256 cellar: :any,                 big_sur:        "98f9e78fd2f0042ad6f96cec615f98d10d02a257efde9045334082528f074e97"
    sha256 cellar: :any,                 catalina:       "7770a8754ec267a41c1646641114a22603d32777ef51f047a3f1d1a12a4c50de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7d0d956a5e0f1294faf75eced1d83f97c952729e6082c3c575bee50092f0f32"
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
