class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/v0.0.44.tar.gz", using: :homebrew_curl
  sha256 "f79edfa56d9355d815011606d93e74b1fb128f2a4cffbc408d8b629763e70ac0"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4ea2e37e6d81f7f6c6906ebc03e9cd3b3ca5938a754366a1ba2a47d0946b2289"
    sha256 cellar: :any,                 arm64_big_sur:  "e9ce7b4822513e87d6e4c022272e6379c8c92f9ba401b21ac5e654de0e024c21"
    sha256 cellar: :any,                 monterey:       "eb579b2efbcbe99d860613098978bf4679d7afc2ddedff08c142016af8d95879"
    sha256 cellar: :any,                 big_sur:        "96a34921f5d81cde4b61b45d0d8c0431828da19880ce4bf4227d30229b860842"
    sha256 cellar: :any,                 catalina:       "4950d16bc35f56f9e06b5b650702df62a28c6519320501beb6cf2cd8196c1e2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb98fb290d952d993b1aa89da646be34b8b683d16b4ab077b12b3a1d8bfb421f"
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
