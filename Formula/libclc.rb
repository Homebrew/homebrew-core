class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.6/libclc-16.0.6.src.tar.xz"
  sha256 "61952af79c555d50bc88cb6f134d9abe9278f65dd34c2bc945cc3d324c2af224"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc9c0dd53dc0846a507a7eb445d950400e4a37a1e587d6fa6f3ae6c4ea0f200f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc9c0dd53dc0846a507a7eb445d950400e4a37a1e587d6fa6f3ae6c4ea0f200f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc9c0dd53dc0846a507a7eb445d950400e4a37a1e587d6fa6f3ae6c4ea0f200f"
    sha256 cellar: :any_skip_relocation, ventura:        "cc9c0dd53dc0846a507a7eb445d950400e4a37a1e587d6fa6f3ae6c4ea0f200f"
    sha256 cellar: :any_skip_relocation, monterey:       "cc9c0dd53dc0846a507a7eb445d950400e4a37a1e587d6fa6f3ae6c4ea0f200f"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc9c0dd53dc0846a507a7eb445d950400e4a37a1e587d6fa6f3ae6c4ea0f200f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c16d51be82c19ebd19059721d57b3145d79e3d3db2f9cf1836beff0866db5603"
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
