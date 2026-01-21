class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.239.tar.gz"
  sha256 "537fee825ce2cee1b55c7e937ecbaada185aa5952562faba108cb1b8a2505df0"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "03847d1582316dae759a2af299976f6bbbf2caf889a3ec8ee2603200f0f821f7"
    sha256 cellar: :any,                 arm64_sequoia: "45e70694ba4d45c0e669550e57190f996dac2ad54f1e95b656bf25294eb65c40"
    sha256 cellar: :any,                 arm64_sonoma:  "548955ad9e510d317445e113e73a6ffe559d75dc464c20a47526c711dc8a8850"
    sha256 cellar: :any,                 sonoma:        "ceb243b4efc54f131a280b4656214f98c119797e34fc76ab9f634bb178a4cd32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d729ed201da2aa85ec108e0fd57af4632af4eb656f178eb2bc870f1a8ac019c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ee3bc8bf342626b009ac16a80c7ae5a956bb491220d453dd33c1c264ad2fd07"
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
