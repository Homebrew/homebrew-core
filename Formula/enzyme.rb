class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/wsmoses/Enzyme/archive/v0.0.11.tar.gz"
  sha256 "cf82e2a3bf701775e6c9514c2f9a35b5cdd037c353077b145a649189427f7ff5"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/wsmoses/Enzyme.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "80c586c3e8e94cf217caddd42e638024fddd7d601b71a985c96cfaef95f3ce09"
    sha256 cellar: :any, big_sur:       "02b55a45ace3e8e5a6a8decdd3c75529cc8d2c0bab88cbf1a128eece935260cb"
    sha256 cellar: :any, catalina:      "03f43c75ddb4ee25918425f4210da8302e277ba8f0cf37d30e1a6a997889dc02"
    sha256 cellar: :any, mojave:        "111d03cab8fd7cef649ecf339713d90df3f4eedc7b798293adba3287bf65d591"
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
