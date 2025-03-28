class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.173.tar.gz"
  sha256 "b8477fb5bead9e9ece76d450ebd0afee99914235c6e1a6ef8c05bf288e3c0478"
  license "Apache-2.0" => { with: "LLVM-exception" }
  revision 1
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "16aaedc0b87dc2b61e23b424e0a8c1f3bf02102a93d10f6e62dfc0334d68c33d"
    sha256 cellar: :any,                 arm64_sonoma:  "05365c4c5bbd1a90b3bb44a6f0375f10b1ee5a9a52d5186f9961871a02d92a1c"
    sha256 cellar: :any,                 arm64_ventura: "493009e564bb65f6c1c8cc40d70489d807a0e4bb3429b61eb94b1f54a2eb2986"
    sha256 cellar: :any,                 sonoma:        "8437883e004eaf34d537cfa0987a90eddc298f766f082077741ee7169071e875"
    sha256 cellar: :any,                 ventura:       "f20e7ae7234785397eaa6f65224f774d14a6267380ccb603f4a13c64573153e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e689dfa116ce00ca9ecd71c88e2e9f0c93698b14f83310a3fda2fa99c629832a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f52aa39f8ae9d3d0247251d5ffc6700fd227c3c33ab84fb9d7226006b4cadeb"
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
