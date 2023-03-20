class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/v0.0.51.tar.gz", using: :homebrew_curl
  sha256 "9a42bf852a6e3776eebf87defaf16d450faef06c4f042564b424f55a1dac5bb8"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4b5cd98e651bc0a83135a755e4c24b3643a7a6c5680db34443dc013cdced59b5"
    sha256 cellar: :any,                 arm64_monterey: "db85f06913acf7a39cc3103352b7b26fcd92014efbf9dd1f9e8403f766c3121d"
    sha256 cellar: :any,                 arm64_big_sur:  "cc6563da874ed765c5e41c8778ade5da12616ec63cd28e1ed3c82d94dccba308"
    sha256 cellar: :any,                 ventura:        "5ef159673340053b77c9fc6e40721d37b6cb9f77e380666426d86abd40d496ae"
    sha256 cellar: :any,                 monterey:       "648216aef6392e0be78fcb25951f0fb0b67338c93eea83bd0b778021ade37913"
    sha256 cellar: :any,                 big_sur:        "404db8bc1e9667e03d6f2f75da61517ea44b76a1f530574c58195c101d7900c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "add6d620d5dc1e910765389040d484b5d117835e0fcd37609922ba03890dd478"
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
