class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.311.tar.gz"
  sha256 "aa179472df99b4d6b0ac5a68550dd7f7778208c5a9a96a183fe49bc1614096f9"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "fb9c1af00efec7e4bd5afa995e3f25240a59f4d903241e570d9c6706a9618364"
    sha256 cellar: :any, arm64_golden_gate: "0639f4bd00d8e630b2e3298fde8d6a3fddfb9a1a4e8a7faa555cb9d1c81de729"
    sha256 cellar: :any, arm64_tahoe:       "f458bf0aed3aa60a956dfc2f8738a2731a133650835b3450ea89d4c2b7cc40dc"
    sha256 cellar: :any, arm64_sequoia:     "a166e878d4b74b65c205795f49d12b9211fab6aa8e05698fe9eb59524d9ed428"
    sha256 cellar: :any, arm64_linux:       "21e87ad0a2ffb5c30dbad63a14c08d772d481e6b2b5966195a3792d54f4b3b04"
    sha256 cellar: :any, x86_64_linux:      "49f6157839ed3cb2148c7a5956853f343598c2b4ddc618650ad091f8a65ff818"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  def llvm
    dep("llvm").to_formula
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
