class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.244.tar.gz"
  sha256 "c9a4fed2456e4c9c1adffe6914e535807a5a951b05ecec87f150e7ccd58e22cf"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "afda1d7a3f1c8b21db8976e7780a09c8062a78bc54ce30d46c6a474844f626b7"
    sha256 cellar: :any,                 arm64_sequoia: "69f53db3da62cd58832471fe03afb62a430c8efe26a663a495edb89f2ebfecae"
    sha256 cellar: :any,                 arm64_sonoma:  "7012ab1a9bf18ea9fac316c8354905bd5c0b1342fc4d6c19ad49f48a161a717c"
    sha256 cellar: :any,                 sonoma:        "4a29da10570eee2f5660a35f406b435d9fa78b80bf58a0738cf9cd8dba64568e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07609f8e64ab92a462add119d954b75356c222ba4d58d26075e4ba735c89d99e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7fa77c3aa466bd8cf149e0edb58c48c17e867110cb5d68bc8441714827ab780"
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
