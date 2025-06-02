class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.182.tar.gz"
  sha256 "629ad8602a134b62284922a4e3a55d7100b533f56989b84a28a6f776a8e18a5e"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1959e6fafe6af55733f3ef907c88b3e0444d6598ee4fc5142317a280660a2e0f"
    sha256 cellar: :any,                 arm64_sonoma:  "b09cf6ad8ce8c462ec3e4cc89d0b9899dfc17cb80445f104d0c6a3f33edc699f"
    sha256 cellar: :any,                 arm64_ventura: "3323dd2217d0dd693622b2fdb586b1150b76541b2f02a253dda080ca3d7ad18c"
    sha256 cellar: :any,                 sonoma:        "bce3f6fd78730ef9f54b6ecd8838f8a5d34ae91f8842b1fc5302572328891ddf"
    sha256 cellar: :any,                 ventura:       "94f5a750875738d1fc31003ebfebe58d55e665e8e2f4714ae0258c197547cc72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4a469ef330740387314e515881b7edcf07245f3d762365a418cec7f63e1785a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ad58b0657df1a9e07a0a7da6d28ec52d61028b3d3b7eac141ce2c4b6139e6f0"
  end

  depends_on "cmake" => :build
  depends_on "llvm@19"

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
