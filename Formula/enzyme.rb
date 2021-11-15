class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/wsmoses/Enzyme/archive/v0.0.21.tar.gz"
  sha256 "13ec2a28cf41f0ae3eab72f95e2f04c565514b15154f06f2fea6a885e01ad20f"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/wsmoses/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "0d44e44dca299867c97e990e903470a02e065c18899fd5b34b70998d48f1cbc1"
    sha256 cellar: :any, arm64_big_sur:  "3d5a9f2a46a9365ed73f0865430b184b564878762e4fd1af9e9542369bd97801"
    sha256 cellar: :any, monterey:       "9723671449915a1a1a1d63195ad81b8e4eafd74adc6a85b88ac10de517b52baa"
    sha256 cellar: :any, big_sur:        "632298a17d476b3eb08216a1f6c0593970422204129348194be17710b40448f8"
    sha256 cellar: :any, catalina:       "8db8e0aa8eb0f9250c7a4d2f03f59dc2aee31ace769a36f2cc7804dd895e22c5"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

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
