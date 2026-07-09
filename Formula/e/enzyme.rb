class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.280.tar.gz"
  sha256 "81be96332ae43b6d13b9ae03fd86c880e598f93ef3357ce2bd8df53c024b94f2"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "105be230c81b0f24b36a5007b2fb4146c3c91c40373a19b8df59357f79467b1e"
    sha256 cellar: :any, arm64_sequoia: "da3fd138c837d7cdc49e0c015d8a6673ac73e256d28e0a9a5d2c1bfa96988ade"
    sha256 cellar: :any, arm64_sonoma:  "6f6b64e616616e592550d7241380966705c5bcea6a47b8ff809a173e45c5935e"
    sha256 cellar: :any, sonoma:        "4d0853d904406e54e0c95d053de927c731af997696cb09ccf92e32505fee8631"
    sha256 cellar: :any, arm64_linux:   "50e2b5dceaaff1124a57a18e80a9b4eea702362743c37b4a3cd2f118067b37dd"
    sha256 cellar: :any, x86_64_linux:  "f9ab04511d359b2563f195579d9aef8f79f850bbe7298aff9b0692bced9f1bc4"
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
