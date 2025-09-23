class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.1/libclc-21.1.1.src.tar.xz"
  sha256 "eed2926f2b981c10800573de3eded1ba41de0951f93f6d7c574c0896b4b1c816"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0384b26c58c06215f7d08eeb286af61b2aef537591af4f9035e668f5a772ec17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a659e3f78e86000f6bb834bb62b82ed6a08644940ac68b3a0c8562ea0ac2f2ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a659e3f78e86000f6bb834bb62b82ed6a08644940ac68b3a0c8562ea0ac2f2ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a659e3f78e86000f6bb834bb62b82ed6a08644940ac68b3a0c8562ea0ac2f2ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "a659e3f78e86000f6bb834bb62b82ed6a08644940ac68b3a0c8562ea0ac2f2ab"
    sha256 cellar: :any_skip_relocation, ventura:       "a659e3f78e86000f6bb834bb62b82ed6a08644940ac68b3a0c8562ea0ac2f2ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a659e3f78e86000f6bb834bb62b82ed6a08644940ac68b3a0c8562ea0ac2f2ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6da5aec26780439194c1c2a9c3b434834b541f0205a1bd7fa354fd1ea67a8bb7"
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
