class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.310.tar.gz"
  sha256 "b5c0a0d86c08d49016dca95c9cadbae14177b1e8a7abe2ff8d0cbc6b7b2e2012"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "28bb200c7749051ddf70241c06c75857c44336102ec574cfa98c4ac04a762d58"
    sha256 cellar: :any, arm64_tahoe:       "909053b4616ae6ef0e3517694ac0e254bb6d2022d909255f583aa5439d1c70cc"
    sha256 cellar: :any, arm64_sequoia:     "299b3c8ffd76f11fe6a36273b40813fbfddd3ccc753fd370e8422221d6bb48a3"
    sha256 cellar: :any, arm64_linux:       "82d49803e3af8b101687ebcd21fb6be2dfbb875946ca7dee307a45e56769acb8"
    sha256 cellar: :any, x86_64_linux:      "5e42973706dcb96b564cc02d4115319d570083f97e408ad7bf4cb7dc89344548"
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
