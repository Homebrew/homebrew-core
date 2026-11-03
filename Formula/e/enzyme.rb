class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.304.tar.gz"
  sha256 "73e284646e2ca93af5799907c4b0e75bdd97dffc115ad0e9f818b2c5661c06a1"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b1936a8c8863bd41a0ccba61425e11744a5ffe6885be26ba3bada75a8eb7e0dd"
    sha256 cellar: :any, arm64_tahoe:       "be589763d4fa7c472106a32e24139ffa6d4807b23bbcada870de0919bf102e49"
    sha256 cellar: :any, arm64_sequoia:     "7308039cf17ba1af9ca06482cbd0300beea186ce1adf5193750e8a574b15f6c2"
    sha256 cellar: :any, arm64_linux:       "9ab258fb5d0647c3167ad687b6e0a7c720c32c05b7a07d1d4fd7622ba5340c43"
    sha256 cellar: :any, x86_64_linux:      "29f58d4bb68eb75fef548b41e3c11424e4060ed812532a953a3a8adc5d38e75f"
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
