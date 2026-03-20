class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.253.tar.gz"
  sha256 "1d0290acfbcda168fcd5a0fe43db7e028a439753919e3498d9d6ec0d8ea0ed81"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "59c3c38a337a77b6e7d283ba3c23ea60cac5de03dca93b2606269c4cbc191529"
    sha256 cellar: :any,                 arm64_sequoia: "381a656bf72292d08a5e37b90113d744babc8d1f35e5b0bbb21c320df1cd5638"
    sha256 cellar: :any,                 arm64_sonoma:  "120844d47d634b86b09c273c14dfeb7ee361ae5241c785942c911a2ba3d58bbc"
    sha256 cellar: :any,                 sonoma:        "53b0aea49a7cf291b7416f39c5908e18535be390209484f0656f485a93d04e5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57dfe5b0403643cb997c5df46c508efa8018f2452f5f552d8eb7c181813cece7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09b140dc41f8150925806aa34846c11bb25bca02e36a77bc282ff518fa4ffabb"
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
        printf("square(%.0f)=%.0f, dsquare(%.0f)=%.0f", i, square(i), i, dsquare(i));
      }
    C

    ENV["CC"] = llvm.opt_bin/"clang"

    plugin = lib/shared_library("ClangEnzyme-#{llvm.version.major}")
    system ENV.cc, "test.c", "-fplugin=#{plugin}", "-O1", "-o", "test"
    assert_equal "square(21)=441, dsquare(21)=42", shell_output("./test")
  end
end
