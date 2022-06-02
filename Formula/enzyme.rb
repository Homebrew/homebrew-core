class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/v0.0.32.tar.gz", using: :homebrew_curl
  sha256 "9d42e42f7d0faf9beed61b2b1d27c82d1b369aeb9629539d5b7eafbe95379292"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "04e47cfda3485c4df271162b649275f58c7ed781823fb917f3dbd60214124000"
    sha256 cellar: :any,                 arm64_big_sur:  "9d6d5f0d76f69362ba9500fae44594de4d4e759aeb1b51aab7e2384ec169b331"
    sha256 cellar: :any,                 monterey:       "12d753a32f9489c475838570d0460f2e844da14290198f9cd88c283680acb41d"
    sha256 cellar: :any,                 big_sur:        "2307c4c8134a5a0ff874fae794239809857ac0e4c3a2356a8957bec7a6fef64c"
    sha256 cellar: :any,                 catalina:       "fdf1711a192400521cd69bb5ef1b449bbab529f5d30f1f053bcc1ba7328df687"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57695c072bc9b6049d6a7bb251173c190ddc1f76152f6ffc13cfc431f3e9ce5c"
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
