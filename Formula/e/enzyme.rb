class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.238.tar.gz"
  sha256 "b6f4bd9b6aaa138867b9acbf8f6e9ac8e3b58a2af1850e1d26272f0c361bb539"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "136c2e2915de93040b04117c1b92e7e9b8f1fa5a71dca4a457b4c6207eaef957"
    sha256 cellar: :any,                 arm64_sequoia: "7c03a3e5314914afd8becb20f7dbc29dd58ecb2c2663b49c2b8eb4f5e9ed1ea6"
    sha256 cellar: :any,                 arm64_sonoma:  "32f6ac5529e2abbe86d12a33bef5c5a1fdc983a82b2df9002e36697064820376"
    sha256 cellar: :any,                 sonoma:        "c35e66e46cf443dea74991634ec4d4f49af0cd01e18cabac2ef6b60fa6df7310"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9a086ed3612bd2e5c73920eb5db6b3f0f78882afd77f47affa63e9c7436ace2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4a68f61b709ffbf86c39a204129b034bdd3708a01fb894fecc3edeb6200c904"
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
