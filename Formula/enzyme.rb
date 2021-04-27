class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/wsmoses/Enzyme/archive/v0.0.10.tar.gz"
  sha256 "6fcee5390541e259f26def103f0423df990ebf364933cf2a3610a08de3b0691f"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/wsmoses/Enzyme.git", branch: "main"

  bottle do
    sha256 arm64_big_sur: "455afc6a9e4c8c52c683fe064aabdd6aaa212d3581db5b5138a0ee8d2f5f085c"
    sha256 big_sur:       "a2b615f56c372801bbdd2860a8ef74c0cde69ebd82f7ffbbc6e79230a0db2ca6"
    sha256 catalina:      "619e440cad7a1b494af3b22d92052d3df4f42578ae40afb98de9c02dada1fad4"
    sha256 mojave:        "0f8594cf38cb590904b702c10b548fe643a7780bfa72b952f0e650c46c78a2c9"
  end

  depends_on "cmake" => :build
  depends_on "llvm@11"

  def install
    mkdir "build" do
      system "cmake", "../enzyme", *std_cmake_args, "-DLLVM_DIR=#{Formula["llvm@11"].opt_lib}/cmake/llvm"
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

    llvm = Formula["llvm@11"]
    opt = llvm.opt_bin/"opt"
    ENV["CC"] = llvm.opt_bin/"clang"

    system ENV.cc, testpath/"test.c", "-S", "-emit-llvm", "-o", "input.ll", "-O2",
                   "-fno-vectorize", "-fno-slp-vectorize", "-fno-unroll-loops"
    system opt, "input.ll", "-load=#{opt_lib}/#{shared_library("LLVMEnzyme-#{llvm.version.major}")}",
                "-enzyme", "-o", "output.ll", "-S"
    system ENV.cc, "output.ll", "-O3", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output("./test")
  end
end
