class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.293.tar.gz"
  sha256 "54a8838f0781bfc0c64fa4d55148d7b68ff4a919e006e1211ed988e4017b5c36"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "82ae8c16c57ac265f3fb7893cd906a00e79d90cd6e4ebde6017424d6bde4c164"
    sha256 cellar: :any, arm64_tahoe:       "56245d67250eb1018b1a9d25e5d2a7e1c486f95d4b6ff3c40c21cbd089b12083"
    sha256 cellar: :any, arm64_sequoia:     "e6a4caece393c91a0904f4551d1ea5df0ed3cb61a21a9b5a10de28b5d62d9759"
    sha256 cellar: :any, arm64_linux:       "22692d96ff950f1b04b0eba1777ab406a49bd8cfa0795b210576630ddec2457f"
    sha256 cellar: :any, x86_64_linux:      "d6358b1472b58c29cf633104fbf7b666304dc985a8916c0e3822f714293564ab"
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
