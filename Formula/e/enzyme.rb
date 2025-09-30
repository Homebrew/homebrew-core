class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.202.tar.gz"
  sha256 "3eb7dec0f0fb4eff9f1e4a632e68d1a94e63364c014abc419d0f5e1b655ec1bf"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d17e569927e30c0483d995f90626f3e9d23d0dc7cefebb4233a0b4d3aed71ea5"
    sha256 cellar: :any,                 arm64_sequoia: "3c0dae1278bd963f4f81025fb14361ddc508d0617c7257b12bdec02582fdf997"
    sha256 cellar: :any,                 arm64_sonoma:  "90d89fe1a2ed21d0e2af6b0863637d710f27924d274a49c74bd78c3f23c122f7"
    sha256 cellar: :any,                 sonoma:        "264a5ec03c80154372c2ebfed20764946c426b9672c44fba10114f1cf1f8a97e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8141feefccea40bb2a88ad8cf03cc42a85942072766306bb8574c5c7d9d55ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca95448c34129dd4c6318dba2d75e9e8a9968b194afb895e37bfd50c50152204"
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
