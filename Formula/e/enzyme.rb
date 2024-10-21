class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.156.tar.gz"
  sha256 "b530f5fddc835d8813a5bc3a88ec4164fe0bd97d394407abcfcbf34cff2bd48e"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "243e0f73538266e5577e124ee292b1afddca67434ff585c2edaa8ab4322ec891"
    sha256 cellar: :any,                 arm64_sonoma:  "4ecfe2aef4e723db3f45bb240d50c351f245f89e17cb56c4c28c5e609c210f5b"
    sha256 cellar: :any,                 arm64_ventura: "5ff28b35b1b288ca400cdeeda19c8a41a39fed637aa8075c3e111878358556d3"
    sha256 cellar: :any,                 sonoma:        "97e636c3afc0d72c857ad3f485427fb8ba9d6db810320497083aca782940e9a8"
    sha256 cellar: :any,                 ventura:       "47f6c9d6c952afdd8b383180c715040ebd7ae7a66511be2a74877aafeb90d9fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e48620116ebfb32f91190941961d90bc1797c9c2e3cf0d413c50e6a47a9a5d41"
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
