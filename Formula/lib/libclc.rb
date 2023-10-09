class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.2/libclc-17.0.2.src.tar.xz"
  sha256 "c3613a7e56f2a9af36639c1c77c52b29083ff65f3ba225ea676155cc5467d665"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d05614a3c6a65d89d9747a11dad7c57a323387c0b82fdcdee51f78024d61246"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d05614a3c6a65d89d9747a11dad7c57a323387c0b82fdcdee51f78024d61246"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d05614a3c6a65d89d9747a11dad7c57a323387c0b82fdcdee51f78024d61246"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d05614a3c6a65d89d9747a11dad7c57a323387c0b82fdcdee51f78024d61246"
    sha256 cellar: :any_skip_relocation, ventura:        "9d05614a3c6a65d89d9747a11dad7c57a323387c0b82fdcdee51f78024d61246"
    sha256 cellar: :any_skip_relocation, monterey:       "9d05614a3c6a65d89d9747a11dad7c57a323387c0b82fdcdee51f78024d61246"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6d129e3eae32f53b98a222e94b75545f9c955757d1db2dbb48df538b9bf6fe5"
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
