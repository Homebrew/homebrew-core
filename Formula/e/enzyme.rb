class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.87.tar.gz", using: :homebrew_curl
  sha256 "8cd30fe1493c48145249dec725a8282182ba065b94501ecd8ae0ec0bbbf154ab"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7d32cc1b7009e59ae23830396cda5d2c92fb0da1c5898edae900ff5f15cefcad"
    sha256 cellar: :any,                 arm64_ventura:  "57fb7f72bee99028e8c91b45e25f350698f62d44fc9944f05e4b6bd54b9cc0e2"
    sha256 cellar: :any,                 arm64_monterey: "33164572b4096c2066507da68700e1184ed2212c467631c6019d97d931102b3f"
    sha256 cellar: :any,                 sonoma:         "5e037500e953ea6510a4ec8675cd4e6ace3df3c42f2f3df2f5a4e0f2b79cc948"
    sha256 cellar: :any,                 ventura:        "7ff81c7661301f28c7e0d5f8b79832e81a77a34fa5c714f568176f04b511afd0"
    sha256 cellar: :any,                 monterey:       "46692291054a164ebaa8434cb3f78e0cc3c871a3e3a70e407d451a70d1320b86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfb2ed27fc755739e17189dc1036f460faacdd29e7e3d391f86357e259f39bb7"
  end

  depends_on "cmake" => :build
  depends_on "llvm@16"

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

    opt = llvm.opt_bin/"opt"
    ENV["CC"] = llvm.opt_bin/"clang"

    # `-Xclang -no-opaque-pointers` is a transitional flag for LLVM 15, and will
    # likely be need to removed in LLVM 16. See:
    # https://llvm.org/docs/OpaquePointers.html#version-support
    system ENV.cc, "-v", testpath/"test.c", "-S", "-emit-llvm", "-o", "input.ll", "-O2",
                   "-fno-vectorize", "-fno-slp-vectorize", "-fno-unroll-loops",
                   "-Xclang", "-no-opaque-pointers"
    system opt, "input.ll", "--enable-new-pm=0",
                "-load=#{opt_lib/shared_library("LLVMEnzyme-#{llvm.version.major}")}",
                "--enzyme-attributor=0", "-enzyme", "-o", "output.ll", "-S"
    system ENV.cc, "output.ll", "-O3", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output("./test")
  end
end
