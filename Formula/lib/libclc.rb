class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-22.1.1/llvm-project-22.1.1.src.tar.xz"
  sha256 "9c6f37f6f5f68d38f435d25f770fc48c62d92b2412205767a16dac2c942f0c95"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0765271d6d15c0aa2d94d2b62ce8cbdebf032c6678b093e288b43acec03865e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0765271d6d15c0aa2d94d2b62ce8cbdebf032c6678b093e288b43acec03865e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0765271d6d15c0aa2d94d2b62ce8cbdebf032c6678b093e288b43acec03865e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "0765271d6d15c0aa2d94d2b62ce8cbdebf032c6678b093e288b43acec03865e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0765271d6d15c0aa2d94d2b62ce8cbdebf032c6678b093e288b43acec03865e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6904317c64b928e48276d7564f17f726d397d79fc855488ce6f0c3cf385dd688"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => [:build, :test]
  depends_on "spirv-llvm-translator" => :build

  def install
    llvm_spirv = Formula["spirv-llvm-translator"].opt_bin/"llvm-spirv"
    system "cmake", "-S", "libclc", "-B", "build",
                    "-DLLVM_SPIRV=#{llvm_spirv}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    inreplace share/"pkgconfig/libclc.pc", prefix, opt_prefix
  end

  test do
    (testpath/"add_sat.cl").write <<~C
      __kernel void foo(__global char *a, __global char *b, __global char *c) {
        *a = add_sat(*b, *c);
      }
    C

    clang_args = %W[
      -target nvptx64--nvidiacl
      -c -emit-llvm
      -Xclang -mlink-bitcode-file
      -Xclang #{share}/clc/nvptx64--nvidiacl.bc
    ]
    llvm_bin = Formula["llvm"].opt_bin

    system llvm_bin/"clang", *clang_args, "./add_sat.cl"
    ir = shell_output("#{llvm_bin}/llvm-dis ./add_sat.bc -o -")
    assert_match('target triple = "nvptx64-unknown-nvidiacl"', ir)
    assert_match(/define .* @foo\(/, ir)
  end
end
