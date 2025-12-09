class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.229.tar.gz"
  sha256 "282c060f5446455a5fe26e938bfdcd4cca4b1ec3059022baeb0c7683e3441990"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "111070a73cc2d78eae5ff2387f7b14a68483bb373de00a5af62e1920cacb75bf"
    sha256 cellar: :any,                 arm64_sequoia: "ecfd8eee4d67b30f34040ecb17fd000fe30b256989619ed6a9ce41acaa360ada"
    sha256 cellar: :any,                 arm64_sonoma:  "b2d4a01a2e2b70c1996f32c797a3f92af3af401bc8fd05f4d4658991d06ba970"
    sha256 cellar: :any,                 sonoma:        "ebf6360489985306d27b7808d7e5c59b7f7011b8ef49769c36b1fea82ba617d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6cbc41fbaa7da131559515c81d094e2e6e546ea4b1e4e6ac7d3fc380f0e2472a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f89602588430ed10991d82849070dc7c385bd3ebba693eb63db129983588e183"
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
