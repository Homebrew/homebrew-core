class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.173.tar.gz"
  sha256 "b8477fb5bead9e9ece76d450ebd0afee99914235c6e1a6ef8c05bf288e3c0478"
  license "Apache-2.0" => { with: "LLVM-exception" }
  revision 1
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3f88e3b59142f0de61619116a5c11fb7e3bb345b14bc58aafa1733e1bdbb754e"
    sha256 cellar: :any,                 arm64_sonoma:  "f7f806a7a12cff8993c874d73d642127688102206eafe04ebfc428286754738c"
    sha256 cellar: :any,                 arm64_ventura: "96204665896a4cf2c1ed51a8c1882c1aa5e0667051b54821562559494c306e8b"
    sha256 cellar: :any,                 sonoma:        "6397a8f2ae93aa03705814d6b7d78f10eed8b1b90e12ecc2d60a9e26bb84391f"
    sha256 cellar: :any,                 ventura:       "41fd27dc2008825cb37619b76c9a913e4305a1e4deb62d20cb3ba87750ca3205"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed2f4ac20223c02293efc08bcfc5d33266752e0e8966eda4e8c401f62f3e5ad1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95e651173a0e1476b7b870a7000a223260d27de9a0c36f3fe8c12bc46d43acef"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

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
