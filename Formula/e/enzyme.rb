class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.81.tar.gz", using: :homebrew_curl
  sha256 "4c17d0c28f0572a3ab97a60f1e56bbc045ed5dd64c2daac53ae34371ca5e8b34"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "9f00ef93d91d115bb7b36236198e8cc5dc4def41b55cfa98d518c029847c182e"
    sha256                               arm64_monterey: "259f2a400fe00d00cda5b527dc6ffc331ec6135e5090a103f0d321ff69f564cb"
    sha256                               arm64_big_sur:  "b28405e04d31cdbf48f9e68806ca88a26cd394443344bf64f3d7385f75efaa5f"
    sha256                               ventura:        "9926b5cbc141a4908c534a25550f593c7198380f845a994540440ed7f2ad9dce"
    sha256                               monterey:       "50e42e5664f42269996c834482c44ac5e9447086453ea5a3acdbc1bc5227199d"
    sha256                               big_sur:        "2a147b76080fea9f166e074942a813aa6f5fe1129ca8bd4dcfbcea1edda9771b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f437b5bed5c6870faa81794599761b306b66df7f27115cf2f013172e7d13070d"
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
