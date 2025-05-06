class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.176.tar.gz"
  sha256 "0ee69239d8383cccfebc753919597c6d203d3e67ceed1cf82bab42d7bda8c21d"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "18d360d5745266b421f98deb3b5bb40654966bf3255da7442f38bdec555aa348"
    sha256 cellar: :any,                 arm64_sonoma:  "ea754461dab0e98aa2aca048b487987d9b04e06cbc47b8817b7d46afb84bdddc"
    sha256 cellar: :any,                 arm64_ventura: "496bdd858fba97391c7714e3cb58965916a181db952444abd69ff1683550238c"
    sha256 cellar: :any,                 sonoma:        "ea7338b1c83038a66b220537f955cfde69744e096270b588565b8939721c38dc"
    sha256 cellar: :any,                 ventura:       "a16e470a543dca1d76e155572e957955363ece8a6010401fb46888192edcc53c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "582ebbadd56a9fae641b91cf2c7bc3263fc2b02a659b790091aba8e7f169166c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2677cddea04ee08ae9576072e8dc3522e32d48c416cd57753fd459132151224"
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
