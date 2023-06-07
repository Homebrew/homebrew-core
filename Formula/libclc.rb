class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.5/libclc-16.0.5.src.tar.xz"
  sha256 "95ab6e946b8bc85e249ca286affb34c94f49939cfdddc0c544272c9e4132039b"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24ec562ce8c7a763d84f311ecb08399875fdd8d2044b75eb906aabd58f622765"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24ec562ce8c7a763d84f311ecb08399875fdd8d2044b75eb906aabd58f622765"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24ec562ce8c7a763d84f311ecb08399875fdd8d2044b75eb906aabd58f622765"
    sha256 cellar: :any_skip_relocation, ventura:        "24ec562ce8c7a763d84f311ecb08399875fdd8d2044b75eb906aabd58f622765"
    sha256 cellar: :any_skip_relocation, monterey:       "24ec562ce8c7a763d84f311ecb08399875fdd8d2044b75eb906aabd58f622765"
    sha256 cellar: :any_skip_relocation, big_sur:        "24ec562ce8c7a763d84f311ecb08399875fdd8d2044b75eb906aabd58f622765"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac8e7616b13dca08b0384d2e29aed18640eceba426aee77575d2cec5a7e90924"
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
