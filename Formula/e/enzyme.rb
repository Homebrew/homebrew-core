class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.123.tar.gz"
  sha256 "92a0552d7a77f3b5400d05c74e7996029a2cc37d999e09535120486e9f24cbb4"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d1baadaa4d399d7028c7b17916f8b2aeee761247e29995203d5fba9962760343"
    sha256 cellar: :any,                 arm64_ventura:  "96aedcda2826e42b11659c4b1ad9c65b45c03aa596299eede83ccd1b4b09e6c0"
    sha256 cellar: :any,                 arm64_monterey: "64e83cffa8c3e6af39a599600422e6ff0c162d8fd77d06204ae34271bff9a9ab"
    sha256 cellar: :any,                 sonoma:         "fbfe57de34173e46ac5e7740c6702aab0fb917713719245741fc1200f886ca7c"
    sha256 cellar: :any,                 ventura:        "fb96d0467bd13a7221493df5c97de7cec04892c749d2e45c72b798c390f6ac7e"
    sha256 cellar: :any,                 monterey:       "1f3e73f8c60ad5929ef5bfb2267ed429d7df4a0a2c1cd8327fe84d42486f067d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48b1da293b05ad81dfe8da9beccec34af7009e99d4df487c635af1e8e5399956"
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
