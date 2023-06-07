class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.68.tar.gz", using: :homebrew_curl
  sha256 "e055ff6999575da4f3f3f709e9c0a5a8e8d39bf48cc3c9af0ca1b419ebf602ed"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7dfa5efb2d974ac51d35cf2aad601ff04de9d6c87af489b327146302b34e20b7"
    sha256 cellar: :any,                 arm64_monterey: "d1a892d50970424f8a615f7b0741e7309ded85da22db2b197b908f1a0369c880"
    sha256 cellar: :any,                 arm64_big_sur:  "e3468a1490a848c2a7d17519e25e81cd4717f5c2d48b2edd0e24c55ecc014e57"
    sha256 cellar: :any,                 ventura:        "56609037d12f2c20286cbd7de7faef082ca1925e75ca06b2400ba51beadb0a66"
    sha256 cellar: :any,                 monterey:       "0b230fa1bc5dde0c4a6615e8ce7192230095aad5adbbad959ce313e1375f7abb"
    sha256 cellar: :any,                 big_sur:        "cda64bee6e17a95cd745b872f32342095be842cc7c39e717e4a12617601e82fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b56e43f4838cb383d6c912ec0effe78319d93606ddfcd6d4fb4e564c31898754"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

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
