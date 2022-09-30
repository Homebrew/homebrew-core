class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/v0.0.39.tar.gz", using: :homebrew_curl
  sha256 "a981217ee9a4862b732aea0cac64fe6965ee4b3af13242e5c174d8117f84bf24"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "54c15cf6ca405df2732b6248f6e22b3cf17063828b9d514fcbcf2237761d980f"
    sha256 cellar: :any,                 arm64_big_sur:  "f9a88742791d80890cfa60d5a7e93ef3d6130d172d374f731582daf370984184"
    sha256 cellar: :any,                 monterey:       "8159f4000b8c70ea6f005b9a5c0a59041e77719bd4c263d278070739d114d6bf"
    sha256 cellar: :any,                 big_sur:        "a7b228fda86fd3d18f4b87fbddf6d327b4a3d819d5454c00b682d55805f02429"
    sha256 cellar: :any,                 catalina:       "90ee818b01cc3b110283bd08b7f7d43fd822225264bc07aa98bdb212a2619379"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63d7e4be9c9cf06a58d273465af54216c8451162c7d91c1bb89a5e84841a18ef"
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
