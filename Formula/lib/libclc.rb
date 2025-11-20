class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.6/libclc-21.1.6.src.tar.xz"
  sha256 "a1a09ccfa17f2d5fbe5e54271a4a9fbe396950f29f80f52b67a7083fee73120c"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48a464f213f21ac47fb82684e5421392b7a23f9f90f6d9ce5a2937dde531863d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48a464f213f21ac47fb82684e5421392b7a23f9f90f6d9ce5a2937dde531863d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48a464f213f21ac47fb82684e5421392b7a23f9f90f6d9ce5a2937dde531863d"
    sha256 cellar: :any_skip_relocation, sonoma:        "48a464f213f21ac47fb82684e5421392b7a23f9f90f6d9ce5a2937dde531863d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48a464f213f21ac47fb82684e5421392b7a23f9f90f6d9ce5a2937dde531863d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0efb35fdfab532b335c640a826d541158eb89edeb8e3a12ae5e8bdc5f911a3f4"
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
    ir = shell_output("#{llvm_bin}/llvm-dis ./add_sat.bc -o -")
    assert_match('target triple = "nvptx-unknown-nvidiacl"', ir)
    assert_match(/define .* @foo\(/, ir)
  end
end
