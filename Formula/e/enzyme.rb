class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.306.tar.gz"
  sha256 "14fdf6b96a8e706cea5db0cd4d6640753851762164aa4733cd751ea5fb9533a7"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ee0b697069ce8200f208bb3f0921437c9a8901e562bff892a576d93fc42a1c61"
    sha256 cellar: :any, arm64_tahoe:       "cbb65f88f0782c1fae8870a686e12b346648d21cb13e4e293edff1419766882a"
    sha256 cellar: :any, arm64_sequoia:     "fb28374717f7eb6a97a0da7b2bd56e1c8f529c4195a76e52f1b2ba1448d4c535"
    sha256 cellar: :any, arm64_linux:       "3921a5ab49ad4119c3853e0e47e249fe2bfdc6ead51aa9c0255cfe3a5f902c6a"
    sha256 cellar: :any, x86_64_linux:      "9a59f15605a89e4c4cb21cb620346f82664936bb9e066e52889139f3cb4fe932"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  deny_network_access!

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
        printf("square(%.0f)=%.0f, dsquare(%.0f)=%.0f", i, square(i), i, dsquare(i));
      }
    C

    ENV["CC"] = llvm.opt_bin/"clang"

    plugin = lib/shared_library("ClangEnzyme-#{llvm.version.major}")
    system ENV.cc, "test.c", "-fplugin=#{plugin}", "-O1", "-o", "test"
    assert_equal "square(21)=441, dsquare(21)=42", shell_output("./test")
  end
end
