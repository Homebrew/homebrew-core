class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/v0.0.41.tar.gz", using: :homebrew_curl
  sha256 "c53dc84f35bee829275f78b49b0d0ed7f9fda755a502e25053971cf09f171750"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "dfd2963c91dc113ccc98ba718d185b6147bcf721d192c22107933aa1865f4794"
    sha256 cellar: :any,                 arm64_big_sur:  "ced71b82637b4c3a27e4cfee17e6477524db8b6b6204fa8b0017e394fb5579d0"
    sha256 cellar: :any,                 monterey:       "485070b3bc559f54cf5f728ba3549b6269f484a35a5d57fea048a2a29a6ab4a3"
    sha256 cellar: :any,                 big_sur:        "0253996084666013f45baf33bf70d9ea6ee6010c8f5ed97237b29383deb0b3db"
    sha256 cellar: :any,                 catalina:       "1133b7ebd75de5c55573f7280362a76fc58778a640d511f9663c1e095e5f5139"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aabd7e4922feb56932dab73b333cd39eb0bc299c954ceeb12b92bf075c8a572c"
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
