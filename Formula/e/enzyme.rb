class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.220.tar.gz"
  sha256 "96526a1bfeba6d5ef504e08b420c6c3fa356c8a2011f9c9dbf5d1dff844f263d"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "898fc0840bf7aafb56e319828d10f91283c319964a01dead3f492293ad34a4e5"
    sha256 cellar: :any,                 arm64_sequoia: "bc3fc1e2e54b0991974787f174431d7cfbd3fbe2cd807f9592a42a92b7a8a5c4"
    sha256 cellar: :any,                 arm64_sonoma:  "3120d4bc6b69526b2b8587578cd7c36c386a6d20ca4b17e7679f9cbbafd81093"
    sha256 cellar: :any,                 sonoma:        "6bdf14debc1175a321229e53b5d49d5d329b510beb75426db1854c31d2862d29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "238ba595bc6d22dd883cca084c20cfe48589ccae1e980aa44793438b4dba2c3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b676d2f33c6cbfaed437527d7e6b514e230764a8de159aa248c400c49299bde"
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
