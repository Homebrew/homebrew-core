class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.60.tar.gz", using: :homebrew_curl
  sha256 "c24c88dfe11b355056f2f8a8d7563badaea55d774b81b07c41da5f744740aae9"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "124bbd6d33855a82288180964162564220d8f25d856f53a8e6edb9f42eef9a13"
    sha256 cellar: :any,                 arm64_monterey: "601fc21d6b786987206fac4190473955bc3078030bb5b351937a7f23b6e2b199"
    sha256 cellar: :any,                 arm64_big_sur:  "fbaf33aebc4c8aa09483cfe3cbeb1cb7b2a36c1e27482c041ff321d4bf296e19"
    sha256 cellar: :any,                 ventura:        "7362cf68a58ad7746772b8eaecbd923330f2ea8a4efa648521cfc4b007750e95"
    sha256 cellar: :any,                 monterey:       "f281eb27fe1f90a035ae92f423b79a738cf37785a14849457a72b4ba12909d5e"
    sha256 cellar: :any,                 big_sur:        "d14cda9dab0e2acb93a50b4ae6d72d3465673320bd3ac0cbdcd6713f794de15c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7a55e543fb0866b743b099219a3226e45f7cec14013744b880ee9ecbc3baee6"
  end

  depends_on "cmake" => :build
  depends_on "llvm@15"

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
