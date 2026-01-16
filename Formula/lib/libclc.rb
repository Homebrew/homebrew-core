class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.8/libclc-21.1.8.src.tar.xz"
  sha256 "6c2677362a53531c35edf482bdc9171ea0471ca0a1e9138ac9b5a1782925616f"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e5fb8611e1c4e10cd9f9e7ccbde609008fbc304f6b2e1402ff4d8ba0bd8cccb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e5fb8611e1c4e10cd9f9e7ccbde609008fbc304f6b2e1402ff4d8ba0bd8cccb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e5fb8611e1c4e10cd9f9e7ccbde609008fbc304f6b2e1402ff4d8ba0bd8cccb"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e5fb8611e1c4e10cd9f9e7ccbde609008fbc304f6b2e1402ff4d8ba0bd8cccb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e5fb8611e1c4e10cd9f9e7ccbde609008fbc304f6b2e1402ff4d8ba0bd8cccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bf35105ccf554df20fd0c16314dcdbd3b922f7c667a1050d27408460da8eb58"
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
