class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.103.tar.gz", using: :homebrew_curl
  sha256 "208987ad4d1d9846e8fc724539addff3b9cb21d6e306850c1ed3a40390186a01"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d6ac9d88fda48a6393a4b430a168d50369569ca704d71b70bf1f620ab871fd5c"
    sha256 cellar: :any,                 arm64_ventura:  "90ca1de7fb0b523d2c3feee0817800a8739db5e2268362bea02ac2f8498c2df8"
    sha256 cellar: :any,                 arm64_monterey: "e87d5fea56b99ec0a43b9fc16c53244c7302af527d89acaeac628ebffe97ba61"
    sha256 cellar: :any,                 sonoma:         "7bf31f4c8cf14d28882262bfc76ec5d02414df108d5d7390dc0af40bbc233508"
    sha256 cellar: :any,                 ventura:        "4dac6e9971a0faf400c6e1985370162c350969d70953af861107cf1d7c289e95"
    sha256 cellar: :any,                 monterey:       "8c7003827a7701a47b44681b7016272d12f3d79daafecff7dc7f13a16c7676b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc1f05dc612e0c22ef50ebe81f89da6a4f76b477b804e86ba645ea71937d633d"
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
