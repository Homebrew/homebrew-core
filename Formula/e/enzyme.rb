class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.153.tar.gz"
  sha256 "343be32ec4386fbb0c41d2c4e2910687349a1669ccc0bb7c81cab883a232771f"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6d5bb3c517f6fa37e48b47827b28ebfbaa875c27aed27a0d7a20184d91a39c97"
    sha256 cellar: :any,                 arm64_sonoma:  "73edd5e70e8984bcac91914a07f436e4df3769901396b964b1e1c76adb899df6"
    sha256 cellar: :any,                 arm64_ventura: "469355759a8cc8d9615eef267c133fd2b8fb86e698ac034a0e12d92f3ceb2806"
    sha256 cellar: :any,                 sonoma:        "9a78301702c58b37bf37db8773f27ed2a49bd93752e071e843dc2a370a6c9d6d"
    sha256 cellar: :any,                 ventura:       "335dc9d3bfa44de60ee4e2cef528b02844919285db8dc6639a1b51be3daa1378"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9eee7bd71ec8c14cb53a6e657f2cb72e4165ae8bdd35f4ac72b6d27966b15ce"
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
