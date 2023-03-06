class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/v0.0.50.tar.gz", using: :homebrew_curl
  sha256 "784f8293b69722db2d77f6ba4101752083f90aa907c7143e16747d6d3ebfe637"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c8eaa39679d55f3225dfeb3ea6d7c50165a7a137a99facb9b25a5c0c62735ae3"
    sha256 cellar: :any,                 arm64_monterey: "52584b67167cab3af85048abdd20e992092b4dbfb6f0be9288777f5d35cd4540"
    sha256 cellar: :any,                 arm64_big_sur:  "22911823d862a830a27aba275ecc1c13a7ec1b7ffefee379cb94cd880d53a4fa"
    sha256 cellar: :any,                 ventura:        "749b291c5181b87586ce32ecdb2a4433aa2ceb980eeef94d55f5fbb008da5ce5"
    sha256 cellar: :any,                 monterey:       "c18fc648460bc9212b3b5fb0329264e3a1f0c286fe97f549621917f69950f636"
    sha256 cellar: :any,                 big_sur:        "0ba799fedd41b1bbc8a07e8fb3f7172bba0380a69fca243b4da8bbf3eea7620b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bd0ed9b1e4547546d2c9c2b1eaa86b091a6d002587574cceabd49a9ce130824"
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
