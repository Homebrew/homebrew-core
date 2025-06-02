class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.6/libclc-20.1.6.src.tar.xz"
  sha256 "c6c431b0ab5d929395ccd367e87bbde4b1d622588e40460b92202424454c05da"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6fdbe23dcc9cf06c6e1890955501815060dfd22e8909c0dd11f4b9da16070e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6fdbe23dcc9cf06c6e1890955501815060dfd22e8909c0dd11f4b9da16070e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6fdbe23dcc9cf06c6e1890955501815060dfd22e8909c0dd11f4b9da16070e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6fdbe23dcc9cf06c6e1890955501815060dfd22e8909c0dd11f4b9da16070e9"
    sha256 cellar: :any_skip_relocation, ventura:       "a6fdbe23dcc9cf06c6e1890955501815060dfd22e8909c0dd11f4b9da16070e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6fdbe23dcc9cf06c6e1890955501815060dfd22e8909c0dd11f4b9da16070e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88b8eedcb7712688e74d9a1c9e5981438e3f1e389326e0a3f2680800d9496fea"
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
