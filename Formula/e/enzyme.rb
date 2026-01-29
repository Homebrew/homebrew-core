class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.244.tar.gz"
  sha256 "c9a4fed2456e4c9c1adffe6914e535807a5a951b05ecec87f150e7ccd58e22cf"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5c27e51cdb583c7e07af50b5c89222363f818ce38dcc7929ddbb84d483d5ef4b"
    sha256 cellar: :any,                 arm64_sequoia: "b99f736758202e20a49cb1fc4c74db99173deeb795bd7204f49e5dfdf2852b52"
    sha256 cellar: :any,                 arm64_sonoma:  "ddc36544615d7991771d2907941c4056dd7f2e07ee3c582bde9f84cdaa8b6687"
    sha256 cellar: :any,                 sonoma:        "eccee2f44ba383c010b15b642160ec960bb5987e13a753f4e10828307c8df88a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4703ed4fdb43e3916074f41ec18ff3e9f71f8c0a20ae11abc6f363130afe0ef7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eed8e1c1d10dbf8601368d5d74d28940a58d287023f7d55aca3d1e79a84bc0d4"
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
