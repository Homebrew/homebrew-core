class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.290.tar.gz"
  sha256 "5eb0365b5e66309d5b604e538fdf8f4307cb93b3dd41d118c5b85e2997487b3f"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3377f276e95eacfa46e6ac7c0bb512784ab55b918556811d948cf81344c5b342"
    sha256 cellar: :any, arm64_sequoia: "145397758b114e5736f76b77192bfc2a22de1acb4c58ecafd405332b952e10cf"
    sha256 cellar: :any, arm64_sonoma:  "50209bddb25269e3cd12cfdd4ab3e6b2419479316743f85975cd7a2d371e69c4"
    sha256 cellar: :any, sonoma:        "1022e0bab6fae398e2b83d473f4f76a1e78a881ecb0cf635bb4c4374e6393c72"
    sha256 cellar: :any, arm64_linux:   "7e516cae1937323b35638f0e8d2687800d6819ec5329d161a7894f7772fd9452"
    sha256 cellar: :any, x86_64_linux:  "f1e31c1ca8f418303ad85f94ce64b882fb60bcf154413a34978189bc5680a311"
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
