class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.79.tar.gz", using: :homebrew_curl
  sha256 "35db74728fc4dee1fab72dd7bb5575872fa17b01959bbdd07ebf18092611d851"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "583764c4605a664c2fcd17243eb4f5e07e3cb3d245fc4c38e4aa7a56b0546520"
    sha256                               arm64_monterey: "c475f842d59f85e933a37310288fe0cb40e91a9fc388497a8f0a1711550f304a"
    sha256                               arm64_big_sur:  "5ad372c02d084400a0fd0d4a2f026d3d9a3c77a90a069affde8d22b314b413e9"
    sha256                               ventura:        "050700d96562f92189004c4f4ed06b0fa2f4bdf3c1ac34d0d06b55701ba456a0"
    sha256                               monterey:       "6a9c1c3bc2545a3a3033574a9c82ef72b768657871c21cfb1608fec9b821f943"
    sha256                               big_sur:        "e4f7e1c9bf46ab38a717e14b720d90f6a803a98be0f42fa024a0f0e2b0f58c18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ff653d0d1dad67a827e9991ffece41c423beeaba275238a33b949256f59bba9"
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
