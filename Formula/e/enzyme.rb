class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.103.tar.gz", using: :homebrew_curl
  sha256 "208987ad4d1d9846e8fc724539addff3b9cb21d6e306850c1ed3a40390186a01"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "04a21f25601bb2743b650e089a734cfdaaa3ea27bdba4589cd00074d5b9b6247"
    sha256 cellar: :any,                 arm64_ventura:  "86558dccb2cdfd4fc73e303338077442b19c2943c503337253130810f3d602ac"
    sha256 cellar: :any,                 arm64_monterey: "b7bbec7e56164b9fb91303c3a267dcdf78733f1d34f16c246a7ff7269c5bafac"
    sha256 cellar: :any,                 sonoma:         "63c43aef0b42562fa84e0a0245febf4489b4ed5bb3176ac8ed772fb2810ceed6"
    sha256 cellar: :any,                 ventura:        "a83f0e8249d3b62b907d1bbe58d44d7d60e1270ec90362abe402a2717feab6f7"
    sha256 cellar: :any,                 monterey:       "702e2c959855688b3f81bd03711eac2e45e46757144b6499b7156df950c69a98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6852ef524471674c478d8091d2a1e5f5d2a11e2734ccfb6a325e2316b7b8959d"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    system "cmake", "-S", "enzyme", "-B", "build", "-DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm", *std_cmake_args
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

    ENV["CC"] = llvm.opt_bin/"clang"

    system ENV.cc, testpath/"test.c",
                        "-fplugin=#{lib/shared_library("ClangEnzyme-#{llvm.version.major}")}",
                        "-O1", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output("./test")
  end
end
