class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/v0.0.45.tar.gz", using: :homebrew_curl
  sha256 "ca74f04de61a7fc60e544fb83e2c6cc93274edc6be61831581c1cbd4bbf75be9"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "61f3720aadbdcbea258e6f64bc124f75962e83f47fc59822859b13306e491bed"
    sha256 cellar: :any,                 arm64_monterey: "81bdf2d213f5797c805f60426b1ca7dde22e45d5fbb3c57486ada1134d79a07d"
    sha256 cellar: :any,                 arm64_big_sur:  "f525a56085cb681cf3d8136f6209ac7027f435c7a0f4cdbbba921a9248b97685"
    sha256 cellar: :any,                 ventura:        "3f17c117e49e263e00b829d76a07b6b38129079820ce85f38fbce51623a42e1e"
    sha256 cellar: :any,                 monterey:       "2bf4060f9fb792a81124c93c82ed18e99deb3f5def937cd24cad926dbf35ebd2"
    sha256 cellar: :any,                 big_sur:        "2bc027795b081dfb8187ab23abdcd94b579e95539a31789d3e368567e20aa695"
    sha256 cellar: :any,                 catalina:       "1124dc9ed328298b794fe526ba8ec76a770c71dfc45da69e044a03cf589e49fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "966d130765da695f41e69453e5a6021f92733afd09a02c6fc6a1786c8aa6b9f4"
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
