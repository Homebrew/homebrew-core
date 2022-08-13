class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/v0.0.36.tar.gz", using: :homebrew_curl
  sha256 "35661f1a9e00fe9417b512882bcf38e8ff1779a8fff9edeac24138a48548f8f8"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e2e0d2d9b14a92375fd936649d0d584e3fd3b96bf3e0b58abf876ab90239178a"
    sha256 cellar: :any,                 arm64_big_sur:  "d4d18035f17d3fbafb6d3857eb3ac0401fd19a71f789114573061401b2c2a8d2"
    sha256 cellar: :any,                 monterey:       "00d2d32fe07ef5dffbec282f6e9c6a1ae53ff92c32345ef32e14ad066db6ded6"
    sha256 cellar: :any,                 big_sur:        "d9538b9bc32c0aafef854cb784ce3c880f0ab936f3d0c2bbf9b21c61e0f11c93"
    sha256 cellar: :any,                 catalina:       "5b13808c75aed687a5daca589afe8417900fd1a0a401fe229a5961ec0c6e730c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df6bb84fa04bb423835a5db6159d72d7dd17178bd388569235495f22888cbadb"
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
