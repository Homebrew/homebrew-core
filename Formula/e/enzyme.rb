class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.217.tar.gz"
  sha256 "38c1d8c1e2dee92ab75ee1c7830d684c0a4052c6ec354e222646972f0e2cdd59"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d09861a84e90b3128a29ec9a5d84cbb37ed7c5ced5f59dd50d14ee64e539aa49"
    sha256 cellar: :any,                 arm64_sequoia: "eb5be18d2c1ec74b266c7cda6d073029dc2d87c466c3a2a37c32cb805f80d2e8"
    sha256 cellar: :any,                 arm64_sonoma:  "e1c24fb005be7a2ac26614a2c022fa678ff98a0d24f688bc6d3c79f72f352ae2"
    sha256 cellar: :any,                 sonoma:        "91911551c52f2e016e895f6838443b4abb1946dc6f282584b13047ca88c4c0bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3501e5ff9d25c99d224e241d1ea40c0e0e05a91c3b8e71f35fbf6a926cf880c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42da32f6700d7459045f7211febc935f3f7c828c635eda1976102aeffa01eb05"
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
