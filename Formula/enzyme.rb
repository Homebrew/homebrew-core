class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/v0.0.35.tar.gz", using: :homebrew_curl
  sha256 "192b85f08aaac5692cb03f8c3b60916874b98498290cffe40962af689618930e"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  # Linux bottle removed for GCC 12 migration
  bottle do
    sha256 cellar: :any,                 arm64_monterey: "aa7aa7c7e4ff4cca33614cb03e0db9e4ab7cf1e91c0b949f1201ae10c212e401"
    sha256 cellar: :any,                 arm64_big_sur:  "2033f7f9ded57262fa9c75c320d3769024dca502b21bdcb316f58b0f50fc2ca8"
    sha256 cellar: :any,                 monterey:       "cc0790ae94df0016b810320b5d8f23c75282ad4059ea1a5cefaed6a8db5f7122"
    sha256 cellar: :any,                 big_sur:        "02b0797a44f4b369a57eb848f7d4b45676efbef344a6ec9f5eedf6fa7c371af3"
    sha256 cellar: :any,                 catalina:       "012c5cc52c4c2632b6ecac144d772c5b96d61fed28a5dc514c57c2a9aa1db2b1"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

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
