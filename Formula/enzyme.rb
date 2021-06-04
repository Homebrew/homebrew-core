class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/wsmoses/Enzyme/archive/v0.0.12.tar.gz"
  sha256 "d9b003a9a01e87fac1f23a7efcdd8b6cfa578f5d6b43663575b8d7472db5d787"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/wsmoses/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "705619ae918d9392e5d12f27be1114dcf46760cbf57a5a2ef2f253cd831832dc"
    sha256 cellar: :any, big_sur:       "e82c81f46baa233f82b9f1af1010948faa1c432bf95ee39124ca3e5754ac6db3"
    sha256 cellar: :any, catalina:      "39791294c9536c43272b4e8017c69971e0025e0fe6be04024aeb172b7928c1cd"
    sha256 cellar: :any, mojave:        "a1308d9411cd93af02f6a419e116f24cddf6cd848ffc5c019aa54510518959ed"
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
