class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.199.tar.gz"
  sha256 "97c35aaffef39b9693e6de59bd851efc2025e98e9e291c65d05aa90463c58385"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "59a30a418cd0ebc08f076ca8788de2623a83a4d1023fba2e783feb378eea8b32"
    sha256 cellar: :any,                 arm64_sequoia: "4d3c4dae511268bfe80804272abf1f515d6fc05644b60c75a85561d77d45a330"
    sha256 cellar: :any,                 arm64_sonoma:  "23298211a2fcc8f2ea5fadf1e39b640c9faaca1456dbf1e481d61e4a34739628"
    sha256 cellar: :any,                 sonoma:        "f7eca037355be9a3f580e6f1e9ce6eb721cb22265355f1c00dd80729283dd131"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ef1a9bb5428c8defaaa2dca7d70b60df749eaace40f7606c24893c893c02cc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ac1103062bbce9a087bbac2db441c35d3e559bf658550a753659c8d341c55e3"
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
