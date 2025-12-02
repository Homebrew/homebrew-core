class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.226.tar.gz"
  sha256 "aa2d67ee50a62d490b319013617d6dba4017b250de4a3061748370cfb0ab0791"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0e8db887ad50967c4a57902c58cfcea0ea263a3e625154b7692d8dd3004abddf"
    sha256 cellar: :any,                 arm64_sequoia: "0c8cc6be0a4f065b4d98a510f39cd84218ebcf45db0ddcfb094adf923aff1056"
    sha256 cellar: :any,                 arm64_sonoma:  "d931ef29a4ce4bfce7935f26c3b07bf946ca15309ac644e00a5fcfdfb12bd372"
    sha256 cellar: :any,                 sonoma:        "b8d1cd621172153c11dfe85c10564873e0b51f72e1793733eba61662e145c99b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe4f6018f05cc38bfb9f4cca2d23e826099764d84bb61caa9ce7c8995f61c58d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae24eca2a5c7e31560ee0b5a6adc1dcea2700085fa5c4bb4a63a5af52f5c7a7a"
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
