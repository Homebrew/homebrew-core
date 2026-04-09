class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-22.1.3/llvm-project-22.1.3.src.tar.xz"
  sha256 "2488c33a959eafba1c44f253e5bbe7ac958eb53fa626298a3a5f4b87373767cd"
  license "Apache-2.0" => { with: "LLVM-exception" }
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ade860b92b5326a59d9c439be0b26a5efe3b5036b4ae5ad1369ba02c6269dfe8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ade860b92b5326a59d9c439be0b26a5efe3b5036b4ae5ad1369ba02c6269dfe8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ade860b92b5326a59d9c439be0b26a5efe3b5036b4ae5ad1369ba02c6269dfe8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ade860b92b5326a59d9c439be0b26a5efe3b5036b4ae5ad1369ba02c6269dfe8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ade860b92b5326a59d9c439be0b26a5efe3b5036b4ae5ad1369ba02c6269dfe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4befab302f4d5b36fdc346cc6be544d2f415f7af56a2c05303551ae12d033006"
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
