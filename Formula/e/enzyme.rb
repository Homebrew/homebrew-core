class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.256.tar.gz"
  sha256 "9334895dc805bf9089709587d66212a96d7612bc2d6ad0c670d95fcc904496d7"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cc6cce42711ccfabebcfc637c204c8a84cb655fe945b4b9351164d08d0fb7f3c"
    sha256 cellar: :any,                 arm64_sequoia: "9a9940a1f6ba2d91e52e56a093b4f50980a100cfdf9454391b09231a3d4876d9"
    sha256 cellar: :any,                 arm64_sonoma:  "a205dfe5f1d477e8d7e2e54714cb2136112defbaa447a3045528828d72f81fc2"
    sha256 cellar: :any,                 sonoma:        "c3346e9400b39a0846903339516b56d5fca37c74c4ec93bd3b73d3b46cd5b85b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82467d86c829986f128fbda8b3fca3252599bfaef05955945700799998c6b260"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fabe2f36526dc316b3cb632eac975d1db5d19be7212c7162357905b8ced7353a"
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
