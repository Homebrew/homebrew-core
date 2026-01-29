class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.245.tar.gz"
  sha256 "81ddcf6e10b40b8d5ee41c85312709ffb6da9ebc54ba88145107255cdf5bf277"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8012d1feeae05c1a9b5c4eabd45f8e0c09131d34913e250c8515b62c16b4e729"
    sha256 cellar: :any,                 arm64_sequoia: "4b7666fdb9bb0e2f191702273bc53092b1a83088b0108e997ab5deade809cf23"
    sha256 cellar: :any,                 arm64_sonoma:  "d68f78bc60a84acbd90af7f65b027f3b98fffad18fbd3b66e9729f7626e4dc2d"
    sha256 cellar: :any,                 sonoma:        "6e5e42adfc1bcc560949b420099e02d4500d1437882d8fc5683774e4699e9d85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78f076d98f7fda8b5196cd851ab8889948ea0f1baf736783a9708d857aea1eaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7d416216277589e59f3f72b2bcde33dd1de67f2f9b178916a42e18752be90ea"
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
