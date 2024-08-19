class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.8/libclc-18.1.8.src.tar.xz"
  sha256 "905bd59e9f810d6bd0ae6874725a8f8a3c91cb416199c03f2b98b57437cfb32e"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25081c5b9f79cac1b7045ac99491683ed5c9d616c1b8b4621113c88d4b17e6a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25081c5b9f79cac1b7045ac99491683ed5c9d616c1b8b4621113c88d4b17e6a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25081c5b9f79cac1b7045ac99491683ed5c9d616c1b8b4621113c88d4b17e6a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "25081c5b9f79cac1b7045ac99491683ed5c9d616c1b8b4621113c88d4b17e6a2"
    sha256 cellar: :any_skip_relocation, ventura:        "25081c5b9f79cac1b7045ac99491683ed5c9d616c1b8b4621113c88d4b17e6a2"
    sha256 cellar: :any_skip_relocation, monterey:       "25081c5b9f79cac1b7045ac99491683ed5c9d616c1b8b4621113c88d4b17e6a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a15271a375571e88edb95d0b3f53c9cd53fe3792b538ed21488c02ce2b360b5"
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
