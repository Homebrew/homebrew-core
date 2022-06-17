class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/v0.0.33.tar.gz", using: :homebrew_curl
  sha256 "49375521e48daa09c03e2bfabb18ca35f7e142abdc35bc5d0144c72aef513efb"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "01d4b23fb7b23e836980c01a1cd1394c1bad7303736f563bfc11cd7cd8509c99"
    sha256 cellar: :any,                 arm64_big_sur:  "ff71ebc0c7e68d37d9707b1094fc57fcb788f84a8a1f9867866b68d79d15a73a"
    sha256 cellar: :any,                 monterey:       "b17e1ec4c708e9c568ebd9c9321bc4a48d9e03f88fa8aa598e7b13d0f1579797"
    sha256 cellar: :any,                 big_sur:        "afaa5cd56853afefdf3b5496a029394b1e671f4c72cb926bad35a591f98f60f7"
    sha256 cellar: :any,                 catalina:       "199f5ddff0188eb9d8b52747f7ce1cd2dc3d83d2676ce32e42b0ba2b5e291f26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "055867f19c9b05f95bf3b36eead5c426e7fabbbe38ff46d9d16c925b87061af7"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  on_linux do
    depends_on "gcc" => :build
  end

  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match? "^llvm" }
  end

  def install
    system "cmake", "-S", "enzyme", "-B", "build", *std_cmake_args, "-DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm"
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

    system ENV.cc, testpath/"test.c", "-S", "-emit-llvm", "-o", "input.ll", "-O2",
                   "-fno-vectorize", "-fno-slp-vectorize", "-fno-unroll-loops"
    system opt, "input.ll", "--enable-new-pm=0",
                "-load=#{opt_lib/shared_library("LLVMEnzyme-#{llvm.version.major}")}",
                "--enzyme-attributor=0", "-enzyme", "-o", "output.ll", "-S"
    system ENV.cc, "output.ll", "-O3", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output("./test")
  end
end
