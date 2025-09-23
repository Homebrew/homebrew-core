class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.201.tar.gz"
  sha256 "2b024d8f2cda557f75db497c20f6be24fea9f189d59f8b17922f6910bd1ec827"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9d4efe1416ab3ce2c6ecb8147b2ea49229556e120bd75a631ee11a7f2fb1c49b"
    sha256 cellar: :any,                 arm64_sequoia: "f80a97b439d91e8b1146b3812dacd2499bb5a09a515a7f7c21fde0bfa81a5b83"
    sha256 cellar: :any,                 arm64_sonoma:  "3a54d70b4b9142c0798fd1cbab7e00c698d44769070a826c1225acd3fedf2c32"
    sha256 cellar: :any,                 sonoma:        "57de5409272d7f072b66a71aeb7e8a5b7b06315badcdc6fa4838712b30381f0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b70af22e249cd6b6191bb1ce75edcc0bed5fd3955bdcba1e5c88b4210a390468"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed3725a48f5527dac5091a07b22c771c036463517bec899ec988737c5b6e810b"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

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
        printf("square(%.0f)=%.0f, dsquare(%.0f)=%.0f\\n", i, square(i), i, dsquare(i));
      }
    C

    ENV["CC"] = llvm.opt_bin/"clang"

    system ENV.cc, testpath/"test.c",
                        "-fplugin=#{lib/shared_library("ClangEnzyme-#{llvm.version.major}")}",
                        "-O1", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output("./test")
  end
end
