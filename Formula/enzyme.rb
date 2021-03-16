class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/wsmoses/Enzyme/archive/v0.0.8.tar.gz"
  sha256 "96349054789cca84a6f94e8d4c4a9a0f7f4677f31ccceed1cd5bfda9e07ed2b7"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/wsmoses/Enzyme.git"

  bottle do
    sha256 arm64_big_sur: "ef9431ee270b73cbbd721a7993474ca8dbc49d1cf36c84db53bd6add983ed324"
    sha256 big_sur:       "b8351c059ca3b6fc1f3de0e8a6ccf29fa87820e506bc0cfb03497b18579ab6fd"
    sha256 catalina:      "cf9a47b84d6f6598fcfb0a048bd99894167821bc08f27b687bf8b58f5ff0b34a"
    sha256 mojave:        "2233fb600cb1c0d27cf2d2c8abe72e7a4ead4392a244b21500ab079d911c87d9"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  def install
    mkdir "build" do
      system "cmake", "../enzyme", *std_cmake_args, "-DLLVM_DIR=#{Formula["llvm"].opt_lib}/cmake/llvm"
      system "make"
      system "make", "install"
    end
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

    llvm = Formula["llvm"]
    llvm_version = llvm.version.major
    opt = llvm.opt_bin/"opt"
    ENV["CC"] = llvm.opt_bin/"clang"

    system ENV.cc, testpath/"test.c", "-S", "-emit-llvm", "-o", "input.ll", "-O2",
                   "-fno-vectorize", "-fno-slp-vectorize", "-fno-unroll-loops"
    system opt, "input.ll", "-load=#{opt_lib}/#{shared_library("LLVMEnzyme-#{llvm_version}")}",
                "-enzyme", "-o", "output.ll", "-S"
    system ENV.cc, "output.ll", "-O3", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output("./test")
  end
end
