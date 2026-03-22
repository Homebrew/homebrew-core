class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.254.tar.gz"
  sha256 "a1796e8e422f99b3638b590e26114ad8154dea42e1d5711ed977610931eeee74"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "035c4c7e16fad88ef8af9d952f4e8ab09e962b72ed86862453e7afafe84c9fe6"
    sha256 cellar: :any,                 arm64_sequoia: "6aab85d245b704311790c6f2475c7f6f24948cef6362ea8f971ca3a992bd972e"
    sha256 cellar: :any,                 arm64_sonoma:  "b97c46598b00c412ea04c1b8acba960f15fe2e8f7ce8799fdf868707ee5df515"
    sha256 cellar: :any,                 sonoma:        "620a3454a079a6d0842bba58d0c85636fc52cc111f6febf5084f4eace9cbc4c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1670c479948b4f7792e36c91bc4a0ceb7a2a6ef71218b513aefbae72fda7eb71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "372b7390b24b682e58ee4793ab55f7dea7d3ad7a8f89faf633cbef574321ab76"
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
