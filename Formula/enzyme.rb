class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/v.0.0.47.tar.gz", using: :homebrew_curl
  sha256 "ea78d82a6edd05d5431a6c27369ef194a0ef14f3344ab6de760b27a3b84c984a"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2536c4dc4170230460de450d23ae5f9ab3a1b4e5e19646e3fcf0c5aa0be95686"
    sha256 cellar: :any,                 arm64_monterey: "748d97a87277e3136814f33f3e60136b196c00f9bf0ea45d8580c6fdacf8ec30"
    sha256 cellar: :any,                 arm64_big_sur:  "51edd8f5b5b1e3ca567dd0e2e2774089996c23ef02d8279431098ec45867d51d"
    sha256 cellar: :any,                 ventura:        "13b4451428acaed932643d609d5526c4c178f9e387e636cd4e23b668418275b2"
    sha256 cellar: :any,                 monterey:       "be62a3e9d5e2ae993c0ade87a6f70a75c49cdd04f46fbc57aead3d7d20f1eea1"
    sha256 cellar: :any,                 big_sur:        "5c2877f770933fb0769f650c93cf0fdc5dd5500e43260a1f12bf47b37ad84efd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8335478edcfea052b23b0f0cac0211d1bdb64022cf7e6c1a11ccf5fb80527348"
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
