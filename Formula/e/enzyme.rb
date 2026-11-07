class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.307.tar.gz"
  sha256 "a1a40ef7ff05a93d9564b93d61d38cdb9f5deb8e82462d783bb8b7860812d3f6"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a7dac21623c401bfb3ad889c31160f7c118e79cf62b556256aaa59029e8c8906"
    sha256 cellar: :any, arm64_tahoe:       "0fc77df58a065c838b78e5fb0770b4a097ee3bd2972de534b13ad5719ca0e633"
    sha256 cellar: :any, arm64_sequoia:     "4241dcadf8b691af86470934f641d35e1465c19ad2384b1e4a1604e670137db5"
    sha256 cellar: :any, arm64_linux:       "bc1c4d021f00854a8c7d1dd22678d3f4717905c5db7e0f19bb0523d65cdb94ea"
    sha256 cellar: :any, x86_64_linux:      "adb4708a1407eff2c54ee67beb26d33f85bc65e2725ee306c094936b2590b937"
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
