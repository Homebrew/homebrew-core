class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.192.tar.gz"
  sha256 "8f770e590fffe9f33a7230e7b22c74a85e6abc2e63f8e8df90bd1f8aca966c35"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "089be8f214d615b4dcf9024a822a20291efb2964d37353f452ac5ce9d9551588"
    sha256 cellar: :any,                 arm64_sonoma:  "f70254509f410cb3478f3f8541b8534e7d1b334c0145f790098ee9d9d8665a23"
    sha256 cellar: :any,                 arm64_ventura: "3e9ca4eeef759d44faed1c2ddfdd6398475a80c762755d9be90ceb21885a7699"
    sha256 cellar: :any,                 sonoma:        "332406ccc6b5bfaa10653c00ba57282ea38cc162baa0dad982cce0fc985680e3"
    sha256 cellar: :any,                 ventura:       "f11e1467cd7593372ae7de39e5789ff0ed4a392bc72dd825894cb3a06cabc55c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f102b964bff93c876288582b9155ceae54046fb5181fe965c76b5b7369c548a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa188b010c466968b2023b4381786afc8e97db05aaf2795d741e6432bd61a95a"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    system "cmake", "-S", "enzyme", "-B", "build", "-DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C

    ENV["CC"] = llvm.opt_bin/"clang"

    system ENV.cc, testpath/"test.c",
                        "-fplugin=#{lib/shared_library("ClangEnzyme-#{llvm.version.major}")}",
                        "-O1", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output("./test")
  end
end
