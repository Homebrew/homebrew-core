class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.4/libclc-20.1.4.src.tar.xz"
  sha256 "08d792747dd08aa0fb3378f5dd4275d7fcb4b286db54eb3f6f9ce3548e13397a"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17fbdaa36c8341641be522624ceaefe6252a9d4a0b9fc3292a4eab293926de9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17fbdaa36c8341641be522624ceaefe6252a9d4a0b9fc3292a4eab293926de9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "17fbdaa36c8341641be522624ceaefe6252a9d4a0b9fc3292a4eab293926de9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "17fbdaa36c8341641be522624ceaefe6252a9d4a0b9fc3292a4eab293926de9f"
    sha256 cellar: :any_skip_relocation, ventura:       "17fbdaa36c8341641be522624ceaefe6252a9d4a0b9fc3292a4eab293926de9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17fbdaa36c8341641be522624ceaefe6252a9d4a0b9fc3292a4eab293926de9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ade3403a9289e3cb14543bdabe80c361ada72d0c87224ce69bcc105984e14533"
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
