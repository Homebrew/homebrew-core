class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.197.tar.gz"
  sha256 "62c32c136a033fc09fd70b32277acd1fe813a673626458abe09c35dd79d9cbb8"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e8b2024d72898f4aa4b5080359a26ec47b16f2978b5339708b247e078b8da2d2"
    sha256 cellar: :any,                 arm64_sequoia: "065f91f25fe978a8490954935ce7bdc6e4d7346422c6dfbd26b74d3271d6d627"
    sha256 cellar: :any,                 arm64_sonoma:  "6dfb287b07798171b3c68f324978a3e8e3661b9d506ff1a18f5c32985118c487"
    sha256 cellar: :any,                 sonoma:        "e791db3abf13d95840f0699b523a89544b6208036a8efde2f472fea1e4ef9c27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46f3d69ad8d8a3a3abf68918697665ae21bc952d9aba9e529d26bb7e3bd12ff0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0b230fdb1a1116559ec2192bebf0ae15a4d7dbacfaf291c36f8f3844f68f8f0"
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
