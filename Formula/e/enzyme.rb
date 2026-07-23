class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.289.tar.gz"
  sha256 "f7cdd6f71c2cee55c42e8b2a1af58f41c799da529810c8546bbd41530a962962"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bb6cf27164c018fd895d4774574901e9484265553b7fe08b11fa7b1047fe9e1c"
    sha256 cellar: :any, arm64_sequoia: "f2204e47239e8195af4c5dec1fdd1adf4d389164bf3735e393a43bec3a8f9bc1"
    sha256 cellar: :any, arm64_sonoma:  "06b1acc95e54ad5f1379cca0f5910631b30ebd5e7df4c4e012da94fa85a1fdcd"
    sha256 cellar: :any, sonoma:        "923368331e693230e65366e703c840b6887fc1945dfab23725c301c4882b7f45"
    sha256 cellar: :any, arm64_linux:   "e8aea792f78f4b14a381d6661a1d3566437d7b2d4f959c1f669c0f0b3e84de66"
    sha256 cellar: :any, x86_64_linux:  "0ca9b9bdd7734aa7c41bca7da5386ac9763f35a144560d71e3e49b76d23b1dee"
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
