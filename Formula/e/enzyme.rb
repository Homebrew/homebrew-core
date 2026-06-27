class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.276.tar.gz"
  sha256 "28e6e273acb464c11b1e2f4bb863dea389cc7b0b63c78005027fd945ee9da701"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1ef66f0818ece17b732ae4ab62748f73d88cf84c2881f42ded6ce1fd097361ec"
    sha256 cellar: :any, arm64_sequoia: "e0046072043a2106299ffd49f4b0f455566c53fb90681be977e1ec4be15e2d6d"
    sha256 cellar: :any, arm64_sonoma:  "fb2e1da41abde91d1037f5351c7266bdb0c34dc9b5082b1453ee09a2eab78b87"
    sha256 cellar: :any, sonoma:        "4f5c4ac2e02a34e005206a0b335fd43db6197bf42ad922fd51e88ba3de6d0209"
    sha256 cellar: :any, arm64_linux:   "ff46c06b4250195b428d6fd32116a5e76db81b181fe183f9424d28258042e09c"
    sha256 cellar: :any, x86_64_linux:  "9f1f711601299d2e5312ebb6b4c05d8e8d2e48d642e7dfd74195ae590ca389a5"
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
