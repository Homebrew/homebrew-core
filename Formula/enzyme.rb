class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/wsmoses/Enzyme/archive/v0.0.19.tar.gz"
  sha256 "51729ff4b26f988f3204915cae28b3985987c33386ed0338eb03d1974ddbab0a"
  license "Apache-2.0" => { with: "LLVM-exception" }
  revision 1
  head "https://github.com/wsmoses/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2e432a472133cabefc02dc4d854107e5fc6f18f9ee86ebbca6046d4cbc7b4379"
    sha256 cellar: :any, big_sur:       "208b86ee6c5f86f3021d777ee3b7e402ffbca8b0b64201426f038227cd0de746"
    sha256 cellar: :any, catalina:      "2d22bfc7cd466a0c57acabcdb00c2a21f156315c1aa6f65d820b1c21ca97824c"
    sha256 cellar: :any, mojave:        "12a621ef588fe38bbc9b4446e3be12158e141569ef6038977e44265a86407af8"
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
