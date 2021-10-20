class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/wsmoses/Enzyme/archive/v0.0.20.tar.gz"
  sha256 "7e2eff7de9d3f9b96e46163e709c9a16a303ac9c2b1dbb7e0628921ae4cf276a"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/wsmoses/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "8f53eb11a62867f4d22346745fec9deead43bd7b6c6588b439ba369337cd52b8"
    sha256 cellar: :any, big_sur:       "d6c916a8f6f50e731f17c1d5ea92d1c5020c4e89ac821d6bfcce5348d8acbeb3"
    sha256 cellar: :any, catalina:      "c670cd0e42cd4a2dbc8cf36538004b5bbab9cb3b4355caf1001a66cc4a09b79c"
    sha256 cellar: :any, mojave:        "33c96e0aff8f84ccbb79003878381580293fc3d4fd9da8a355bf995ce57c9be6"
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
