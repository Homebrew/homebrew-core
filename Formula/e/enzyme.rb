class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.249.tar.gz"
  sha256 "0842c14bd3953502bda6e8bdff22e94f3d49b042839f2ae5c3d502a7686ab969"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "13619744bb57d6a5fc8261e92a25f17fb198b4c11e7265f9eeb8e872fdf7a126"
    sha256 cellar: :any,                 arm64_sequoia: "56d36ac253ea485940f6a4da708013d2e1adbddee9f8aedb6708b05d0dd4a820"
    sha256 cellar: :any,                 arm64_sonoma:  "8dd0c684bb330396a058a5d9a50b1016568abb4bc413e063aed2be847c6f4351"
    sha256 cellar: :any,                 sonoma:        "c5b086143227155b21808e6c4fd987931c0d24cdb0b295c9b733a83cce1bcbfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9937e0fa2b77ee9b4b080d8c03205169feb948b5602c520035cf0dfa547c6135"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc8d6562e1a6ccd1ba16680fc65e1371ed0c3f721824577f58feaa1761325557"
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
