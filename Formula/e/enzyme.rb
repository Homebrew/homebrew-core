class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.260.tar.gz"
  sha256 "b70145123258973d67f7ce9e5aadab5ebb35a806da24080e0551513c48712bd2"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4e9c58a165a7eae3ef1b45921c5c5a9c5424ba028e25101304c502c1d3983713"
    sha256 cellar: :any,                 arm64_sequoia: "ebefd8dddc54db86202bf353b55bc9725b00934c0332fc0ed73dd69f51785d61"
    sha256 cellar: :any,                 arm64_sonoma:  "ef39a919ef364c6f7485d0a49397ab2a5c5deaea00b70b59bcc17675743a4ea3"
    sha256 cellar: :any,                 sonoma:        "43173459667c9e15e9559d855aa58c75787a76fe9506251c3141834d1305a0b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e9c3302858bbd9714714d72e4ebd96bbeb57420f8d89c3dbc4babd9b79cee02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe2c0b1d3e197fa2ce84688b9976be8d6d86d8f6b48d2db8515f7c278c1ae9ee"
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
        printf("square(%.0f)=%.0f, dsquare(%.0f)=%.0f", i, square(i), i, dsquare(i));
      }
    C

    ENV["CC"] = llvm.opt_bin/"clang"

    plugin = lib/shared_library("ClangEnzyme-#{llvm.version.major}")
    system ENV.cc, "test.c", "-fplugin=#{plugin}", "-O1", "-o", "test"
    assert_equal "square(21)=441, dsquare(21)=42", shell_output("./test")
  end
end
