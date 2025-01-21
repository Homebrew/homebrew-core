class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.172.tar.gz"
  sha256 "688200164787d543641cb446cff20f6a8e8b5c92bb7032ebe7f867efa67ceafb"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1986ae04d4b99170b2ba189b6e6f432d75432f34ef5bccc5d482d1ce259a9559"
    sha256 cellar: :any,                 arm64_sonoma:  "cfddb6a4d52aa83bfa4b362b5923de91a322d423c0b227d1eddd72964c5efb69"
    sha256 cellar: :any,                 arm64_ventura: "234b2e110d31c982699e867b697723820ec96c71dc2fe3f57da35893a348e2cf"
    sha256 cellar: :any,                 sonoma:        "ec57ea612c564601bad3ad4fb3f1b2e1499b162f2f391c6d9dd6e36ae371b03d"
    sha256 cellar: :any,                 ventura:       "b578a2c3be0635e0f82b5946edb04c56d97a725d7c8ae46b94abb6907ccf93aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08eaf58fb8a7ee08775dfd9a8b005a88e01cf2cf5f2285c05ff7ab0065369de8"
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
