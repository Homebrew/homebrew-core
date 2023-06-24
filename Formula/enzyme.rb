class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.70.tar.gz", using: :homebrew_curl
  sha256 "f656a0b91205ea0ddf780c7e7806e51d9322711199edbcc28d7b1bc24a288547"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "34f3420d5f6a83dad058fa04862200db1454a6fea5de689d312bff08eb0cf4ec"
    sha256 cellar: :any,                 arm64_monterey: "e0a1af7070984d632f30559da5e68a33c0daea6453f7fcac9f1be6b3ce85895a"
    sha256 cellar: :any,                 arm64_big_sur:  "f23d0017df518d4fb7b19c45cd3ed34dbb4dfbbd6692946430ac70bb4852cfe3"
    sha256 cellar: :any,                 ventura:        "34849ace680b397bb81cfc45b8d917bbf5dfb743ebca35977a1a7e2f7f7e5c38"
    sha256 cellar: :any,                 monterey:       "4c09609a85a4b699a570f508400c59c39967e9fb2bd9e597836160c76a819df0"
    sha256 cellar: :any,                 big_sur:        "474b0667aea6b3660a9afc4b340bccf53552b8a02433f08eeab0f60d3bc9c462"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b32da00fdd2293d636424be20bbe0a69c2f924d41944c11db9890f6525e5dca5"
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
