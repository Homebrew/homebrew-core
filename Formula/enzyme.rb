class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/v0.0.37.tar.gz", using: :homebrew_curl
  sha256 "9648c67351e27c5f568baa338c15bf6197374f425a4c99654bbd2c25b25e24e8"
  license "Apache-2.0" => { with: "LLVM-exception" }
  revision 1
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3772cd9eca5715e9b658d8834ef9baee49ceb12a533be1eb2591239a24f932f1"
    sha256 cellar: :any,                 arm64_big_sur:  "b920f27425109bedf2b42a68cd5f7c3e31bd8013be9dc064d4dd258ed7e806ae"
    sha256 cellar: :any,                 monterey:       "b194272ad3c61ea4827aa372f58e50461c12efc4cc8eff629da82e8a48bda41b"
    sha256 cellar: :any,                 big_sur:        "5dd02a73168b0e4d5ccce3e639ea85bd6c2d0fecbbf46751e63e3978a3390439"
    sha256 cellar: :any,                 catalina:       "abfa2726f10fbbb3c61cb63ff09422fa92f925c9b9377306883626e3f7bfaab1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a808e3aca47bb2812fc2e0cfe724e8ae77fde1ed1ac36a73a8efe5a90464106"
  end

  depends_on "cmake" => :build
  depends_on "llvm@14"

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
