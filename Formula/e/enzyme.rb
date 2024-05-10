class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.107.tar.gz", using: :homebrew_curl
  sha256 "b553c75cccbb13c2114ef7d1cabb1175917a058687ff10b84bfbd5256d89dddb"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a6fb2949f029d507db802731a9015e724c4637a290f563449ae9d6c10bb4bc85"
    sha256 cellar: :any,                 arm64_ventura:  "3f919bda815f66f3f0b755dcb907502d0193915ebbb5424535a230448314c06e"
    sha256 cellar: :any,                 arm64_monterey: "2320b6e2acdfa8b9eba24056af6e2a9b36982ed4ddfb97b6da1eb125bf0eccc8"
    sha256 cellar: :any,                 sonoma:         "b2ccbafe7a89b07476c4da50754f5043d209baa34e207b2ec39caf71cbe73a19"
    sha256 cellar: :any,                 ventura:        "d7f6a2ad76e97bcf01e7cc0de57b067afc0492425b1111498242594da8562ec2"
    sha256 cellar: :any,                 monterey:       "2270f74b152bb40897b9e036d780a5a793278143a48091f6bbd8b81770b0bb65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71ffdacec28ab2e7b5564da2dde1eb3f0c4c2910cf011755856dcd858776918f"
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
