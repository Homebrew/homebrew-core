class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.185.tar.gz"
  sha256 "6bacc5db3bf5e3aca55b748b4ecf6b4699a6fc243704e7a7696cc066f5dee682"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1d74c094d918b7600e31418b1b4c5c7791e785404337684d6c0a321f8168f20b"
    sha256 cellar: :any,                 arm64_sonoma:  "f6ba1a7f3c54e3ac176d1a8cefb5ed2c05010d25e622ccbae3b9c9c9ea3b5375"
    sha256 cellar: :any,                 arm64_ventura: "3df4afa45c506288db320eb5384b904c1b3b1a8fe19cfbfcfef871bf3c81a239"
    sha256 cellar: :any,                 sonoma:        "c7031655cc468eaf1e30479971711ff09c1f3e92a29cd6ccab60d3b6c87cd6ea"
    sha256 cellar: :any,                 ventura:       "70f0a20ccb484a468dbb8ff1a59ce1be270056e9211b434477cee723e86b7b7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a62fde712e093229d6c4136b10e08ad7275ae4d4301256dec47493fbfa58559"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6507f940848d192f0ce786d2b2b9298a4e5cdb4a64d76ea4e5d20096849b099"
  end

  depends_on "cmake" => :build
  depends_on "llvm@19"

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
