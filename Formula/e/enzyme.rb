class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.309.tar.gz"
  sha256 "7cf549a0f5ad542dcddc3ca45bb0a453e87149cc7d37b793a2b48d9869ea8ec9"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a641ce049759ad52bb20575d77cc67b54771da52123553fe7ce5f67c965c7387"
    sha256 cellar: :any, arm64_tahoe:       "04e1d6f6fb63dce745e6a4b6e7f875dfe1025ae0c133657a3181b67026963730"
    sha256 cellar: :any, arm64_sequoia:     "1d17a900107e768730e08f5f9e76b3d7d217db26702c30b95c0f92d8dd163466"
    sha256 cellar: :any, arm64_linux:       "2a8b9a712699def5b58164ce7acd5a54d3d145e49ac3b1302c62b60d418a38e5"
    sha256 cellar: :any, x86_64_linux:      "751df70b596e59a987826449d451a6de353d3f755b5c6c3f790e74f51eefbac2"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  deny_network_access!

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
