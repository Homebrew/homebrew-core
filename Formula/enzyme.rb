class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/wsmoses/Enzyme/archive/v0.0.24.tar.gz"
  sha256 "4ff1a5bd31d926c30ca868145a0e1263606ad02656a3c1101a29142c88b34a0e"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/wsmoses/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "075c0ab8b00947778ad2212f10fbd17af50734a44329c395265554b8640cafca"
    sha256 cellar: :any, arm64_big_sur:  "bf75d152afa4d751187cf264be677dd42af65cdb9e77253a983da3af32f3caf4"
    sha256 cellar: :any, monterey:       "3d7434b30582befaf9a41d23f0a27976f526269887788623a62c3dea19296a6c"
    sha256 cellar: :any, big_sur:        "efcf36a8941ced366f358d3ea166fa17a9a185040ffc740e4b1f4c45a8497d2b"
    sha256 cellar: :any, catalina:       "e5a48739c72c69f13f6a38765ba1bad0651e400f37b448ea20c68a85beb464d6"
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
