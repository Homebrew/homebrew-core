class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.82.tar.gz", using: :homebrew_curl
  sha256 "b94a47205194bd8e9edf046b4dd1d9a992a16d00e7282896b0b600e5e01155ca"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "72c36d70c8c8bc61b7466ffade55323d755f077c65bad85780509af044ba843a"
    sha256 cellar: :any,                 arm64_monterey: "bae5199646dc57bc3be567c6919ea32272a52c6c0ca65592ca8fb0d56d416698"
    sha256 cellar: :any,                 arm64_big_sur:  "bd91419c368c2482ae3e7be4c25521746318c701cb961fd2d438785baf3d45b5"
    sha256 cellar: :any,                 ventura:        "613375a2b2525b3bde3625be18ec0baee2cd89a597f19a2213becbbff5d66285"
    sha256 cellar: :any,                 monterey:       "34329ef3648650e762a0d2e1ba3ddfb9f7f7ee129c86d68936a36f6322c5d23a"
    sha256 cellar: :any,                 big_sur:        "c2f79dbfcb70611876f7caf01a11b2e309fca5a36120cae0191f5d3892b6b7c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "144ed6fcc85e4138bde8acc4694e261e7c9a587a7ad2ed12dc2c9772db468dc7"
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
