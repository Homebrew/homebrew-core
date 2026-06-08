class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.265.tar.gz"
  sha256 "ea8013c69b84b8f9f1bfe1fd2a2b2938512b8f51680b68e40d3f36846f85d5bd"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0dca5366f260b85956f798b449b3c0d2da7486c99fcc27e34f13f638ecbb10e7"
    sha256 cellar: :any, arm64_sequoia: "7ee171f99e71565b69d8fe87d4142b5cdd4fb4eba9015b9e14a063530c43feb4"
    sha256 cellar: :any, arm64_sonoma:  "3b039a8f0f3dd2f0d68b38ead713fdd97d95af6245d80d3c018909aaf7328f8b"
    sha256 cellar: :any, sonoma:        "9f4fa83e1b9f4086df846cddbcab3a2fbd48e8dfa794de2e868551298e09998e"
    sha256 cellar: :any, arm64_linux:   "966b2335cf116445bec427f3308f28c14eae3f18383925ea06070ebb7badbe88"
    sha256 cellar: :any, x86_64_linux:  "be5ea4bd72359d03d458d4da307f72071eff4b855f7ee9d1ca97e1e205719fcf"
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
