class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.203.tar.gz"
  sha256 "2135f8836fccf697112554abb67acc7860b7a21db2c4af50d5be6528755beecf"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5586c000f6419a55b7f434d37adaf19857817b26c6073d656f78fbde4863f5b3"
    sha256 cellar: :any,                 arm64_sequoia: "017bfe2fc1a23af0716a415246fb675befd3abf99aa1df8900cad84fe3ce47b5"
    sha256 cellar: :any,                 arm64_sonoma:  "798d27d181f38db018bbf1464bf7825d37634f056c30c0a9a225e8764182f2cb"
    sha256 cellar: :any,                 sonoma:        "e5e60821abe3ef7c83fe318013e1c419f42bfe43a31375e736483cb4e453f28f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b417fe53abd36873fa2226eb870db6f3c37f3278ac13dc91894966afa71856d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e43a9500d3757eda00de73d31766deaf7533752d02581c00d9f754920704cf78"
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
