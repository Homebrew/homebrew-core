class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.104.tar.gz", using: :homebrew_curl
  sha256 "82c2bbd95acecaa9c295bed6e6a82710515771834d57bd123c3c3e19e93f2238"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "aca9c39b7a3a6c8c3b1417412a315dc8033e171ca9cad754aeed01a96bd01271"
    sha256 cellar: :any,                 arm64_ventura:  "c840567aac841e6a892dd5b2529723704b5e160dd7a9d3baed041bfe8844d50e"
    sha256 cellar: :any,                 arm64_monterey: "e0db84ef7986fff95cad8a614e025f38d950317be34e684602bee2632ca78e9d"
    sha256 cellar: :any,                 sonoma:         "de6e164be003a7968f535d7cef1c0110f030d104df1c3b373b8399a5e3049cb9"
    sha256 cellar: :any,                 ventura:        "8bafde70296ab7c66e8ac14bd79d2fabf1c4f2c10df1a3a295ac67a56080d049"
    sha256 cellar: :any,                 monterey:       "e99436990c844f9695f7e6adec42a80d32e29a80d4f63088e56bb2febb28927c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bd19ba9590c6836ce81701d8107115da9241ce7cdbd0b0a45e6c001fd424812"
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
