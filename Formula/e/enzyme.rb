class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.237.tar.gz"
  sha256 "4d09097ae8b7b6ab85d6faba0fd8a969db01b2e2c9a670487a35240e30787063"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7010a568a8ab262a38db5d5554a6e354c43b4e6726f42fbeee9964c657cbadcc"
    sha256 cellar: :any,                 arm64_sequoia: "1cd5570c0e50280fc73d83ce65c3c798572347e3374f97bd7abb6c3546fe6f77"
    sha256 cellar: :any,                 arm64_sonoma:  "648b23d13a0871bb7ba5a000f01ac2b22ee3caf6b6c8999f0e5242aa449e5702"
    sha256 cellar: :any,                 sonoma:        "a340d1cd292d880930b976f63ccf3e70e36c4fff02b20399298dd6c01d29af3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08c42ac7b5078f2a1ebfd135459ad3f12067a3d174104ea41e60a6e6dbc4a64e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89674a5f91d7b90ea3d6e1967385a112fcdd0b69fb5e04fda04a3e0222f4522b"
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
