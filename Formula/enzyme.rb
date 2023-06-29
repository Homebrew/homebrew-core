class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.71.tar.gz", using: :homebrew_curl
  sha256 "9b08d242ea9d9791d0bc51e5e64d7f70e359f91d317cf2b8b0ece614a177b27f"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fb5bfff1790f263eef3f09aebc10250111dbe4d1473cb983a5fd21fc672cf685"
    sha256 cellar: :any,                 arm64_monterey: "73484f24199b32d7bd66acffab6c4c4abab1419e14698a9d9abd2f3d932f7332"
    sha256 cellar: :any,                 arm64_big_sur:  "c89888c1b45f372258b513a3f77fb325d18ae249071f073b74a53d8d379cc6e4"
    sha256 cellar: :any,                 ventura:        "3c8b58907923824509167e5725d46bd56d67eb25301797aab5f45125e5d18306"
    sha256 cellar: :any,                 monterey:       "a89c82003eddb7820a2b8232d66d54da60ff33c843211784c5f05d46e59ecda9"
    sha256 cellar: :any,                 big_sur:        "6f85ead4bbfa0f7d61b5a8224b3d1ca8b85ac9d134fb131d44746cd4b84e7840"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ae8a965c63f06b6ec252abb67018a19dc128046174958a1551fd137f8fdc02b"
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
