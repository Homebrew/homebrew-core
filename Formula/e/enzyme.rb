class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.98.tar.gz", using: :homebrew_curl
  sha256 "03a604f9a6c3782490ae1c39714bb0205132c2122d692997b3511f185dd868aa"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1e88d903143576dd936ec1695d7d4bc30cb5675526635ae873320f256570ed5f"
    sha256 cellar: :any,                 arm64_ventura:  "74e1d862a9416bda27c01e0f44745966383f06450287b09d86913854e55d82cb"
    sha256 cellar: :any,                 arm64_monterey: "07b66016878fc9624a412e7853032402ba29f3225d529f596f6363fda52d27da"
    sha256 cellar: :any,                 sonoma:         "d0cf382379699a2e2314e83b410daa78a10af5282bf1c4c5ea34a0f3125c468f"
    sha256 cellar: :any,                 ventura:        "dc083968696e1277ef7c56a3af6da12b547fc2f27201034ccdaeea5d2a533112"
    sha256 cellar: :any,                 monterey:       "88bfb2abb3a1f51ab7174ae777a97c0e1001ab8c5f196e0f3b1a09c270673eb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebda49ebab8883be7e5708331a11540d1ea0a2943762354aaf2bbb13ec9c8397"
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

    ENV["CC"] = llvm.opt_bin/"clang"

    system ENV.cc, testpath/"test.c",
                        "-fplugin=#{lib/shared_library("ClangEnzyme-#{llvm.version.major}")}",
                        "-O1", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output("./test")
  end
end
