class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/v0.0.31.tar.gz", using: :homebrew_curl
  sha256 "d8c0fd05c1c83c38d01b82b760e6b44c09cdcfb26feabc7893ec825aab40d9f3"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ea836323f425a17f9da35efce157f77cabf394f772a9e31523fb5c7fd1f86d6d"
    sha256 cellar: :any,                 arm64_big_sur:  "8b3c729c45a0eda07a974be7ad63cce0ec68ca3dc4f833d20eb06553b6cfecca"
    sha256 cellar: :any,                 monterey:       "ed61a73d0792a8aea300eeeb385004af2caf29ce505f273951066d0a6358416c"
    sha256 cellar: :any,                 big_sur:        "58276b41afd65d2d4e24ab9eac7a0684d3f1465b8b7339b0751d37211bb44404"
    sha256 cellar: :any,                 catalina:       "25aa3af23907fc13516bf478befb315c29bdb4dc921bac21558ab3bdd1608cb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fef15c7611b74cd3c2bc39878d4b978a0e1b40396023ac43e05ed2a3e0ce791"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  on_linux do
    depends_on "gcc" => :build
  end

  fails_with gcc: "5"

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
