class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/v0.0.35.tar.gz", using: :homebrew_curl
  sha256 "192b85f08aaac5692cb03f8c3b60916874b98498290cffe40962af689618930e"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9721f6f2460a866325c61ddc19bc2be9d23bee83fbfe9bc1e3eb896c3d69a1cc"
    sha256 cellar: :any,                 arm64_big_sur:  "f400ba4834ddd3fc89078a88f571f95c1f468a4a5d51208a461b52df434b7b9b"
    sha256 cellar: :any,                 monterey:       "3271502a1dd7fe66eebe6c3bf9be59ed1d1710ff3353ac77b22a5c642e43ed60"
    sha256 cellar: :any,                 big_sur:        "689215f54b0de047230d738b4a7050f476e72274b1d51e20744c2c81ec854bad"
    sha256 cellar: :any,                 catalina:       "1f665aa37b523a2cc0b549d0a66b0edaca8e11dc0512d2ff9a1da3c4ee2f1ae9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7362f63b852cb3173cc632fc958cae3cfa4f288aeda703a49f66c501d91e3fdc"
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
