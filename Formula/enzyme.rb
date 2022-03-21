class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/v0.0.29.tar.gz", using: :homebrew_curl
  sha256 "81c802c26d007d790e602497bb16023a9b5b3f17c71240ddddeb4736e966907d"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7fa07509dda1a0922967d5822661e5eb669f3d6ec147e0c5d2d3cc93b7688015"
    sha256 cellar: :any,                 arm64_big_sur:  "f40d49e283f2e6f47d12de68780a74e8e523e43e6211f4fa2fc577741bf48635"
    sha256 cellar: :any,                 monterey:       "850b37a53a55a2bda17e419b0b4733026f44667d95d23aaedd63b39da1804bb2"
    sha256 cellar: :any,                 big_sur:        "c7b09d7625351ac8c5994e8390268d833000fa43d76567f2d431b997adb2a204"
    sha256 cellar: :any,                 catalina:       "6f16a5138e4e4429d54934645561bf3d5ea9cd8d9d3a21b77e6bb081b00cc7d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89a8b914e105843e9326184e50282646598150c02cc2a2e761c35d7cbc4d7cfe"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  on_linux do
    depends_on "gcc" => :build
  end

  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match? "^llvm" }
  end

  def install
    system "cmake", "-S", "enzyme", "-B", "build", *std_cmake_args, "-DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm"
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

    system ENV.cc, testpath/"test.c", "-S", "-emit-llvm", "-o", "input.ll", "-O2",
                   "-fno-vectorize", "-fno-slp-vectorize", "-fno-unroll-loops"
    system opt, "input.ll", "--enable-new-pm=0",
                "-load=#{opt_lib/shared_library("LLVMEnzyme-#{llvm.version.major}")}",
                "--enzyme-attributor=0", "-enzyme", "-o", "output.ll", "-S"
    system ENV.cc, "output.ll", "-O3", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output("./test")
  end
end
