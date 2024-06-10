class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.121.tar.gz"
  sha256 "2827577d9882e042dc82264247f238810fb976be96321971ee1f8ff367fcbe68"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9e47b7dab9ec6909a6c93c3dc01b5851f38942b316b940913aceee66d6f52e90"
    sha256 cellar: :any,                 arm64_ventura:  "710e531dca81183b4078035854eee5e61fb3e3ba7608c43ceaeb0d710a3f9bf3"
    sha256 cellar: :any,                 arm64_monterey: "4dfd86ad3845b618ab582277dcfce66b0ffc12db70af39a355f23013497641e0"
    sha256 cellar: :any,                 sonoma:         "311262fed9f591bb15f74a044b3c6033ff46176832b746448e92b3a24bebf364"
    sha256 cellar: :any,                 ventura:        "a7742631748727c8003bbc1a975b7150f182734224f8998203813def9c668b8a"
    sha256 cellar: :any,                 monterey:       "ffceb7d4b84a2c66b992856ac3a83202ee6386913ddd03dbce7d5bc6066d628d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b526b706f78d9fc6418f88c0c241fdfa63950f4ad5494b6cbeb0ad2fea489a4a"
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
