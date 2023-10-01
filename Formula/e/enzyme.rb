class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.86.tar.gz", using: :homebrew_curl
  sha256 "b13cdaed1fbf69152a74850dfabd1a23e778d8a722fba95261cda3277f1994c2"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f27d820d225610b62af9b1915ab58282863c85a44764b33fbfeb7f0dfeba44da"
    sha256 cellar: :any,                 arm64_monterey: "f6045ffba3d92f619a6396395abb4721a3ae4ff929e45c14ae654d2b2a887682"
    sha256 cellar: :any,                 arm64_big_sur:  "0c7feba04bece6d4073e25af38d9e34a4d9bfa358d098f8e1c71f9609e5d743f"
    sha256 cellar: :any,                 ventura:        "d6916f9be363438251447440698e7f45635d06576cea7e1e66c81bce132b4014"
    sha256 cellar: :any,                 monterey:       "da54b0b2b124426a3f984799c7ab3fca12d625868ecee6d4b3c11117894c35cd"
    sha256 cellar: :any,                 big_sur:        "36fd943681a6ad2cc72e3846980ecee06d21c84576fb0f97260567940409b218"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4704431057f697246fa74da6f6c1fdf3aa1b0edce8996c0a9d2cfe5089936c3"
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
