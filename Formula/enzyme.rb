class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/wsmoses/Enzyme/archive/v0.0.19.tar.gz"
  sha256 "51729ff4b26f988f3204915cae28b3985987c33386ed0338eb03d1974ddbab0a"
  license "Apache-2.0" => { with: "LLVM-exception" }
  revision 1
  head "https://github.com/wsmoses/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "a124168993adae9f328840d57f42027fdad8f4dddd60dc3252b6df3ab1fd447b"
    sha256 cellar: :any, big_sur:       "51fbc9afa8e4e97be25fabca384b0cbf69bb8a1f183af926f44f4dbdb28c1e4c"
    sha256 cellar: :any, catalina:      "1aa2ef774514bb286f8db2e239289902ad74e3c75d275533e5660f0e4cc0df0c"
    sha256 cellar: :any, mojave:        "7dcd33561137e0d45caf981f493b9f58b26f387e0f9c2e52c71fd8524076d965"
  end

  depends_on "cmake" => :build
  depends_on "llvm@12"

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
    system opt, "input.ll", "-load=#{opt_lib/shared_library("LLVMEnzyme-#{llvm.version.major}")}",
                "-enzyme", "-o", "output.ll", "-S"
    system ENV.cc, "output.ll", "-O3", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output("./test")
  end
end
