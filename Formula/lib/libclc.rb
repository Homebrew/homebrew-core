class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.7/libclc-19.1.7.src.tar.xz"
  sha256 "77e2d71f5cea1d0b1014ba88186299d1a0848eb3dc20948baae649db9e7641cb"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34d2546339cfe4a4e6b59342c748769187ba560a2e6b314a32c40f953d4e596a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34d2546339cfe4a4e6b59342c748769187ba560a2e6b314a32c40f953d4e596a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34d2546339cfe4a4e6b59342c748769187ba560a2e6b314a32c40f953d4e596a"
    sha256 cellar: :any_skip_relocation, sonoma:        "34d2546339cfe4a4e6b59342c748769187ba560a2e6b314a32c40f953d4e596a"
    sha256 cellar: :any_skip_relocation, ventura:       "34d2546339cfe4a4e6b59342c748769187ba560a2e6b314a32c40f953d4e596a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef445f4088c23fe0189b67d868fce5843e434ac52ee90a9993ee73558b4fb518"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => [:build, :test]
  depends_on "spirv-llvm-translator" => :build

  def install
    llvm_spirv = Formula["spirv-llvm-translator"].opt_bin/"llvm-spirv"
    system "cmake", "-S", ".", "-B", "build",
                    "-DLLVM_SPIRV=#{llvm_spirv}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    inreplace share/"pkgconfig/libclc.pc", prefix, opt_prefix
  end

  test do
    clang_args = %W[
      -target nvptx--nvidiacl
      -c -emit-llvm
      -Xclang -mlink-bitcode-file
      -Xclang #{share}/clc/nvptx--nvidiacl.bc
    ]
    llvm_bin = Formula["llvm"].opt_bin

    (testpath/"add_sat.cl").write <<~EOS
      __kernel void foo(__global char *a, __global char *b, __global char *c) {
        *a = add_sat(*b, *c);
      }
    EOS

    system llvm_bin/"clang", *clang_args, "./add_sat.cl"
    assert_match "@llvm.sadd.sat.i8", shell_output("#{llvm_bin}/llvm-dis ./add_sat.bc -o -")
  end
end
