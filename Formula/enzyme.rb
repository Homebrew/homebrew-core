class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/v0.0.28.tar.gz", using: :homebrew_curl
  sha256 "59f63b757326cda23a0f879ccb7ca18d4b2c276ef3d2055f6ec8818657671475"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b854fb3182bb89d4200c11950f9f8c4b124fbb29dc8043598feb52f9bc5b109a"
    sha256 cellar: :any,                 arm64_big_sur:  "189cb4fd7a233eb17ff3c9abf37222745c5a593926eb5004b8e9f5ed8fcbda93"
    sha256 cellar: :any,                 monterey:       "2f341a17de364f6a1342f44b44546b203cbe959466bdb39ca2d606821cd8a80d"
    sha256 cellar: :any,                 big_sur:        "ab289f19ffc1efd52b3559682c431a0e2f2ec4e03821e1fd36f71e3b08f977cd"
    sha256 cellar: :any,                 catalina:       "3a4fa6ed912b627a0ffb3738fff25547d02217b6542b29945ac0d324229ccd41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b20d831b5eb01a9f9a5d2cc0dfc58465b9aa3627f741b3dfa31755e77668eb6"
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
