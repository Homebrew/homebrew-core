class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.72.tar.gz", using: :homebrew_curl
  sha256 "be3ee19ff5907c4d58f509215fe331846d1b321a81cb125c75218f2581fe2545"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4d8db0b97c47fb0ac8243a4981721e9dfc827844681122a1a025120c5c3378cf"
    sha256 cellar: :any,                 arm64_monterey: "a52b543a9371f3cd8dac8a9dcf5aa1a8cf11d5527581002f8beb689c903a3369"
    sha256 cellar: :any,                 arm64_big_sur:  "9d43413465f759d4b9ecc59ff5695a2ff0d906908eccfb0b947391e55282faab"
    sha256 cellar: :any,                 ventura:        "6c2c35509c590008faf56a01bd845b56b7483c8da85366e4e0f7f1117857bdf4"
    sha256 cellar: :any,                 monterey:       "46e61b8478359de6973033383b4d2a4db9ff2456b7e8de539cb3a21d3f6b2343"
    sha256 cellar: :any,                 big_sur:        "9b2f1350043f6668062639023abcc21b326963b3e5d3842e779da9d2cd98755b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e21523dd0f01a214cb2ab48b14ca570766e087b125798863de1e0036afc5af0"
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
