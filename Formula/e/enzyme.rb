class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.308.tar.gz"
  sha256 "481f0fc90581898912e6adc539d8e19d1255fb96115bef5a1e52fdb50008b3a2"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4b7256341ff2a24c6cc0beaff7e9fd80cd4449b897f798ed30279ae19a92f2ab"
    sha256 cellar: :any, arm64_tahoe:       "e82439e1f149e189e5cf1a597f9661837f18131ccd33623438fc7d60ab57e5d5"
    sha256 cellar: :any, arm64_sequoia:     "f762f5364ba1a664aeea90469370bc80c420c481f72d4dc286fd04b309bd1379"
    sha256 cellar: :any, arm64_linux:       "baefb419ab0d0f23da814ae62c454b8c9f3a2867fe365906ae35599a942282e2"
    sha256 cellar: :any, x86_64_linux:      "d5ae69f24b0f81e98ccbc0304938f27cccfa2863057d4695244841a4e2b9f9ca"
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
