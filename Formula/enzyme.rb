class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/v0.0.40.tar.gz", using: :homebrew_curl
  sha256 "1651faaaf9005412f1c4475fa17fffbebb8dd82d9f1a56d682923ea6787e7395"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "700c9abb65db1b208fe5ed1d33783b6cc68ffc25f13f0f65e0eac3e30bd4e23d"
    sha256 cellar: :any,                 arm64_big_sur:  "b88c4b0f86802fe63829054b4747dd68a0cfe2463a420ab5cec69f222f027274"
    sha256 cellar: :any,                 monterey:       "30785b6cc0d891a1785b350be70b47472d86396f3dff95da13145693aeebe66a"
    sha256 cellar: :any,                 big_sur:        "017c90b7ca2ba16ba7a06bde61711e790f7373e95ef2672a0079b07dab00546e"
    sha256 cellar: :any,                 catalina:       "fdc72212bab30854472104bd2bf20adf8a1488e9cb3c432305fd08c19dbf76f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f016423b8242f3544ab8a72904ef2e1bdcfcd4011595bf2889816cafbc1457f2"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    args = ["-DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm"]
    # Needed for `ld` to be able to parse our LTOed object files.
    args << "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-lto_library,#{llvm.opt_lib/shared_library("libLTO")}" if OS.mac?

    system "cmake", "-S", "enzyme", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS

    opt = llvm.opt_bin/"opt"
    ENV["CC"] = llvm.opt_bin/"clang"

    # `-Xclang -no-opaque-pointers` is a transitional flag for LLVM 15, and will
    # likely be need to removed in LLVM 16. See:
    # https://llvm.org/docs/OpaquePointers.html#version-support
    system ENV.cc, "-v", testpath/"test.c", "-S", "-emit-llvm", "-o", "input.ll", "-O2",
                   "-fno-vectorize", "-fno-slp-vectorize", "-fno-unroll-loops",
                   "-Xclang", "-no-opaque-pointers"
    system opt, "input.ll", "--enable-new-pm=0",
                "-load=#{opt_lib/shared_library("LLVMEnzyme-#{llvm.version.major}")}",
                "--enzyme-attributor=0", "-enzyme", "-o", "output.ll", "-S"
    system ENV.cc, "output.ll", "-O3", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output("./test")
  end
end
