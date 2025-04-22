class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.3/libclc-20.1.3.src.tar.xz"
  sha256 "bc5050fd1bcb7383da37fa13f9d7c075cfa0de2d7f86a6385a62517fdb815630"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f709c64531511db958e3db10e2193c31553a88a40dea5fbb65babc6a9bbd60f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f709c64531511db958e3db10e2193c31553a88a40dea5fbb65babc6a9bbd60f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f709c64531511db958e3db10e2193c31553a88a40dea5fbb65babc6a9bbd60f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "f709c64531511db958e3db10e2193c31553a88a40dea5fbb65babc6a9bbd60f8"
    sha256 cellar: :any_skip_relocation, ventura:       "f709c64531511db958e3db10e2193c31553a88a40dea5fbb65babc6a9bbd60f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f709c64531511db958e3db10e2193c31553a88a40dea5fbb65babc6a9bbd60f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39bf9e0dbe1fec3ffd673c8e23fac0302d133e59d9b8c6c268470a78f4811e8c"
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
