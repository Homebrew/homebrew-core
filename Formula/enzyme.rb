class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://github.com/EnzymeAD/Enzyme/archive/v0.0.54.tar.gz", using: :homebrew_curl
  sha256 "551e48345a738cfc7b115030c54468116d1b9a7bade5e9afca8d55d0bda8f4b8"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a6ce44bc18101e7a97c547312580e0585a08ae85d8eee8bfc12b9fb4b30b7479"
    sha256 cellar: :any,                 arm64_monterey: "8c1e7f77ec1026849ad9631e48fecfd3e4ca70e7919f82a645061b6068390817"
    sha256 cellar: :any,                 arm64_big_sur:  "ed03406e16a69ef78914227026e7cb0fa0722062391852020ca669ced28a9d9b"
    sha256 cellar: :any,                 ventura:        "dda4818c29e05ba71d4e28cac20b13bf2892b852c0c4c7f8fc9c533a6c3689ee"
    sha256 cellar: :any,                 monterey:       "ba8dfe259f401b9a0cd25172ce7d8c8d6ca6682d92a909aa1cb3009723e7a40f"
    sha256 cellar: :any,                 big_sur:        "ef58ba2c57ed841a981a222b4d68862ce3dc25d44300b8fbfbb1b1a81d49bd28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d9c9f70641917400ae6d0c5ec5fa2ca2f83cabccf71e53f972812ccb85a2361"
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
