class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.258.tar.gz"
  sha256 "df851fcbb4292dfbbb7e0df78de4027de69a20f663849f776a9510db50a1544e"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2de3b38487cd16c7222d50d8b9246af39ba072f7c4af87ec0bb8681b75b5e5c7"
    sha256 cellar: :any,                 arm64_sequoia: "5c4f164ef07545bb4c0b7b9050a2e7aeb3ccd2569df9ab9576690a99b03c121f"
    sha256 cellar: :any,                 arm64_sonoma:  "d18ef390bcd996d20073515a134e0851078d62e0c10c8fd357fa79b99bceecfc"
    sha256 cellar: :any,                 sonoma:        "8bf72ff1fd65dc7ed6d5a2974df514055deed0ae61a29f09972bcc0ab928ab4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf9cdb1e55eec615fe406ee338678aff4d12a0759e44f535796a9d0208c25216"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e56f7f80217c45271d4e5fac3862c09a3ca8fe9c5bbc0bb1ffd3277de57092f4"
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
