class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.2/libclc-18.1.2.src.tar.xz"
  sha256 "13465a087f2f13d4f0e0adab7dfd9c538c242f631a8c4571ed85e4e50f8c2570"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be91c2e33f3d8d38f790375edcce98188d06e178467d6bc707ebd3ae105bf0b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be91c2e33f3d8d38f790375edcce98188d06e178467d6bc707ebd3ae105bf0b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be91c2e33f3d8d38f790375edcce98188d06e178467d6bc707ebd3ae105bf0b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "be91c2e33f3d8d38f790375edcce98188d06e178467d6bc707ebd3ae105bf0b9"
    sha256 cellar: :any_skip_relocation, ventura:        "be91c2e33f3d8d38f790375edcce98188d06e178467d6bc707ebd3ae105bf0b9"
    sha256 cellar: :any_skip_relocation, monterey:       "be91c2e33f3d8d38f790375edcce98188d06e178467d6bc707ebd3ae105bf0b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adc39cecfe2fe2e4d928119f6b5876f6811774bd1f058e5154ac3bd60a9b5b44"
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
