class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://github.com/EnzymeAD/Enzyme/archive/v0.0.51.tar.gz", using: :homebrew_curl
  sha256 "9a42bf852a6e3776eebf87defaf16d450faef06c4f042564b424f55a1dac5bb8"
  license "Apache-2.0" => { with: "LLVM-exception" }
  revision 1
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "03e6436577c38f0d9a7e2e8dfee6a3f4b6235bc5758832fb04c6e9b6b3f87dc9"
    sha256 cellar: :any,                 arm64_monterey: "00f5cdf836388f24498bebc11a9c6ddfaf24f6dfde2fafba1d6ba747c21fce56"
    sha256 cellar: :any,                 arm64_big_sur:  "5d09087051da896aaadb16e5d6182b5dab31063ea5732c6c5aa090a18299ddfa"
    sha256 cellar: :any,                 ventura:        "7dad6c637b06737f8c863191984d7b6bc988557458771808d8f2ba48dd0462b2"
    sha256 cellar: :any,                 monterey:       "44e2d121a1ed30cae681febb93c1709f6becedfb02679098999958d270a45957"
    sha256 cellar: :any,                 big_sur:        "940d30155cfc6326d779f776ed90837c941be5f3e189b5c6a6e2b4698d73eb09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a22e0c3902a8e5e38853a1b40f1b75cd0f09f8b5a554ae0626d744045777700"
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
