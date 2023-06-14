class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.69.tar.gz", using: :homebrew_curl
  sha256 "144d964187551700fdf0a4807961ceab1480d4e4cd0bb0fc7bbfab48fe053aa2"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "44d96924f4854d2ee649e5af4b3cdef2982a3d6aa0e541bec0018d3bdc586c19"
    sha256 cellar: :any,                 arm64_monterey: "22d83bc30caa901b100052346c1021967129d7526151f0f135742c390c399d68"
    sha256 cellar: :any,                 arm64_big_sur:  "cc8b055042d637417b96719f55437b8eb326ba600c6fea31645ae605ca888d3e"
    sha256 cellar: :any,                 ventura:        "3fa9d468c8ea3586ca61178e33d48fdb76e73882ef7cb260f72275045d2436d6"
    sha256 cellar: :any,                 monterey:       "f2d0e6a86aea26164e0594f34c71724c7138995cdc73095841e5e2186db76111"
    sha256 cellar: :any,                 big_sur:        "8222401d1acdd95d07f3f361ceff5f19d42f6b46b72ea1a7195d830549dd3f8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "387832a2d157729be4f3774e24b137962e36560eed6406bbc3c7176e66d49f4b"
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
