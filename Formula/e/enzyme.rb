class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.198.tar.gz"
  sha256 "f852d1d223410ff2bac981a8c90900a2ad71fc33035d9c768a97c36d45b91705"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "caa0f1e9ca5565c152f8ffd689aeff77ee91aa13eee590e2372ebc133e63092f"
    sha256 cellar: :any,                 arm64_sequoia: "932bda96295c745f008175ba0bd4988e7dae8d9e54c996b9d2b092bf3aa468ab"
    sha256 cellar: :any,                 arm64_sonoma:  "b8c48039595e223a18ac9f756aa6a8d03858b0a55da6d265b24fdb0eef5156ed"
    sha256 cellar: :any,                 sonoma:        "4ea86adf82195984a8df46badfdd1f1b6ce314d0f4294a42657eb044e1905ebf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03cf7d9105cec451c398c4e5e1bb6cc6d5c8fd3f3167e218d9e80f6095870d18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07635736f31f41dc642e1e20aae6ad01719575f2422353fdbd13494b368cf598"
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
