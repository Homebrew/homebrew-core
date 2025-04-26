class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.175.tar.gz"
  sha256 "e05b810eef8c92d19e43bfdd39ee2a5bcb6a67f9b61ef42b46d16464e07c125b"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ba2cba7d8c37d24a7a17666196e7e78c5d9dfc3be633800d77576054f43287eb"
    sha256 cellar: :any,                 arm64_sonoma:  "02fea6fce7aedd1f11a8321e86e7743df10fb0658be5c86821db2f0295311461"
    sha256 cellar: :any,                 arm64_ventura: "83e364e998c97a3c1ef22ae5f57632776dbfd2341e0e927e14c603b3fac11a12"
    sha256 cellar: :any,                 sonoma:        "048d44836365563eccc90a79a4a9547646d336b121050a69d1112b0d05258e7d"
    sha256 cellar: :any,                 ventura:       "74b6cbc7bb10592a2224fc1e8b49eaf42d1f092b80ca510dd0ba28f89766690d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "558c0b5af0903691c69828d135dde5d073b1908a53fb15dfdd05ee62e7355f88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27b745c0ac6b4f82233915433aef1af6bc20f257f29d1206a08b550977c014cb"
  end

  depends_on "cmake" => :build
  depends_on "llvm@19"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    system "cmake", "-S", "enzyme", "-B", "build", "-DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C

    ENV["CC"] = llvm.opt_bin/"clang"

    system ENV.cc, testpath/"test.c",
                        "-fplugin=#{lib/shared_library("ClangEnzyme-#{llvm.version.major}")}",
                        "-O1", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output("./test")
  end
end
