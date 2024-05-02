class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.104.tar.gz", using: :homebrew_curl
  sha256 "82c2bbd95acecaa9c295bed6e6a82710515771834d57bd123c3c3e19e93f2238"
  license "Apache-2.0" => { with: "LLVM-exception" }
  revision 1
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c9ec8f4bfff40c61f450de5559507f47d468f68478cbc3f7d05d5943202043d6"
    sha256 cellar: :any,                 arm64_ventura:  "c7159c964dc8863cd6b80375238cfadf1cd21d815e1d9a47e361ef88fa40e9ed"
    sha256 cellar: :any,                 arm64_monterey: "7f0fe4841ef4b57e0947975894714890325eac1c68787bd8f94f62ac0c3d1f75"
    sha256 cellar: :any,                 sonoma:         "8be21906ae017184d8a7e090168e02f749d958bda9dcdfe0f2204a12ad0dd657"
    sha256 cellar: :any,                 ventura:        "86a647cd3f170af5a1a855c18d529981604576b7bd76483f4ee9a9e2812e0178"
    sha256 cellar: :any,                 monterey:       "533f5d8f05a76e5d33911c0f11f2993ad900c0212a7b8cad760f5b6462daf861"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b366c8c8f218348ceec37c38e6230be37b64eb9b0ef74eaad92ec20776373935"
  end

  depends_on "cmake" => :build
  depends_on "llvm@17"

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
