class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/v0.0.51.tar.gz", using: :homebrew_curl
  sha256 "9a42bf852a6e3776eebf87defaf16d450faef06c4f042564b424f55a1dac5bb8"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8587dafaa267342e276a2f99a876d99b958a30923840e54fe23cfb3fd44ed707"
    sha256 cellar: :any,                 arm64_monterey: "a141cc747e7ea8781bbfd8510d1758cb1b1f2a549a19d669a0609ec298f77b84"
    sha256 cellar: :any,                 arm64_big_sur:  "62ae255641d727f0213babd1ef8c828627b8fb4a4174105b241728827a9140cf"
    sha256 cellar: :any,                 ventura:        "f71ef758242376b66608f9abc3c3f0844ec3aea61924be528bf3be398d9435fa"
    sha256 cellar: :any,                 monterey:       "5398e011ca08359309a796a8f7b10fd8c0524a43f1886762002485cb6e2c73bb"
    sha256 cellar: :any,                 big_sur:        "102fbbac635e9fa5e6b088683dbbc714cac136607727d3af07deda7b39ea3e0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ef672f03cc1eb8887bcfb9ea91cf3bde09c54c1cae614ecb6b907e5d846cec3"
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
