class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/v0.0.33.tar.gz", using: :homebrew_curl
  sha256 "49375521e48daa09c03e2bfabb18ca35f7e142abdc35bc5d0144c72aef513efb"
  license "Apache-2.0" => { with: "LLVM-exception" }
  revision 1
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "53b0ac1f07fbe0748b86cf07af709e741d7c12b0d951ef9149b855b3ab7cbb21"
    sha256 cellar: :any,                 arm64_big_sur:  "01469c969a3e31ffcb0412681124f3139acefbf7837b1b27953d870dc38c0236"
    sha256 cellar: :any,                 monterey:       "5855d8062e41672e4596be9b6ef547f1beae6b56004b16e521383f079586e428"
    sha256 cellar: :any,                 big_sur:        "4cf1919a3e636e0d6d2c068f33ab88b908197505857c5f6cdcd24040b8272185"
    sha256 cellar: :any,                 catalina:       "18a28cecee6f9596b56c9d1d5458650029a28f7a9711f3c34d0a8de64571f502"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc19b14eeebf4c7647eab6fe1b6e776bc64753b16f4661e086374b2769ad3f8e"
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
