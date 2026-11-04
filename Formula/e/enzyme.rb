class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.305.tar.gz"
  sha256 "72aa9ae6a0477403b25203bebe473354fb0b52d6f90c275b7f6cc9ea5b53aa41"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0e96c555c43ca15296447692525776893f3986aa78f159980f698e614996310f"
    sha256 cellar: :any, arm64_tahoe:       "dfb21c5e7a255ef89803b8c564ec0d3b6bbcc2cd0de98bfdf79506d831c62744"
    sha256 cellar: :any, arm64_sequoia:     "0acff797e940afabf2ab7c649c819975c9ac21b9e18e649979517c0441e372b7"
    sha256 cellar: :any, arm64_linux:       "8a032eb779e1a54c9d8867bb5263cdb8e98a3d765e2d3f23e5db0724b2bbac59"
    sha256 cellar: :any, x86_64_linux:      "446c8c8f7133ad613017baff9ac6cbaf19130939e8b25a9bcfe82f6774eff26f"
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
