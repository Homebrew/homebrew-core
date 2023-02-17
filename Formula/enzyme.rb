class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/v0.0.49.tar.gz", using: :homebrew_curl
  sha256 "7e66e64d1cfb6586b282bee14502db920fe14e87e8928e6b828149a8a92e7ca7"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "14cd84af3c0c3c53b2ea25422cb0690e9d1ff85373b3fbe9b809e24e23d123d2"
    sha256 cellar: :any,                 arm64_monterey: "0c41f20f1f1e85ce5a012376e799f5c85d61ba989635f44dce279e03de414a51"
    sha256 cellar: :any,                 arm64_big_sur:  "0180fa9212cc6ab68cea4d7cb2656ff2323f0740ebf3b04c78eaf77f269a2648"
    sha256 cellar: :any,                 ventura:        "c4c8cf63eb6e118cbb11ba9f597b8282796a1b46fa6e291688f4a5eae5826c9e"
    sha256 cellar: :any,                 monterey:       "1ef6f7b47ad1a7cdf2a5a1f390b56f19246c6e7cd8ca552f7f08554ebe2307c8"
    sha256 cellar: :any,                 big_sur:        "4ef2a88c324596872d158e16a115f4ccacea50fcfdfd802e2632eb0ef8deac8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66cda118fc232dd30a56ccc8d7650386b079b4807ab0ce9779757579d296a717"
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
