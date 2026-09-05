class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.292.tar.gz"
  sha256 "1974c7430eaab3161c4f2eb36db98296aeab73568651b83f2a8212521e1faf4b"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9c42d69b657cbe7b40a61aced403cfa27546a6a0140d0cd41bfdf6e9b7f5dfcf"
    sha256 cellar: :any, arm64_sequoia: "f47e065aed6438927c582212ca5e3ab4feb80683632d6100043214022d58546c"
    sha256 cellar: :any, arm64_sonoma:  "74f2715cf926eb914796d563238ab1908f9e0602e8d088ab9e6d71c3e89de217"
    sha256 cellar: :any, arm64_linux:   "21a6f52c1de5780cf8d4968d9615e2bdbd7853f74fc40dcce0a100ff9d669308"
    sha256 cellar: :any, x86_64_linux:  "3ba45d32397734ccde2b3b718b3aababe3491b09cd2e07fadab23791800a5c60"
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
