class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.144.tar.gz"
  sha256 "74eea3a2491ba3a844fded8e271fecf850d84ec9d154bc586725b40b93bbff2f"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "16b37b8a2c22906898a8ef86e3503f9b0b459e9f9823ad64aadcd2096ca5b9d6"
    sha256 cellar: :any,                 arm64_ventura:  "34b7d038daf8b0881cd63b3ba72a26daa03f852c37ec7b88517cb381de82233f"
    sha256 cellar: :any,                 arm64_monterey: "92ce97f8c7a1d46300fe2a31d6e3b76c42a4c8c5f6324830ddf0bcf45c509a9b"
    sha256 cellar: :any,                 sonoma:         "30c9e63b9a97738fad643c1ce6640f30aa1a9c7e34d4e284f1f768a5c35eb4b3"
    sha256 cellar: :any,                 ventura:        "fec86ebf31810d67cd85aa9be88cd9297149b4be5ed325ad3da0a20758ebedbe"
    sha256 cellar: :any,                 monterey:       "aff27ef5c8e58d8edbe1e3fd880d854fef52ce97835380feb0b06ee5e58e20a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53927deef490d6303dc83e63059b2904e071b6b9caad17d908c6c8e4a3700ee7"
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
