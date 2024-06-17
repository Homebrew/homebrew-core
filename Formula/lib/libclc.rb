class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.7/libclc-18.1.7.src.tar.xz"
  sha256 "bf99fdabd64ebfc688775754edf4c6bd3ffc361906b710ee49107e03fd3db396"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a7365b77740e6e46103a721b8b0b5abc4d32acb51c4c5c519db9f6db364d04e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a7365b77740e6e46103a721b8b0b5abc4d32acb51c4c5c519db9f6db364d04e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a7365b77740e6e46103a721b8b0b5abc4d32acb51c4c5c519db9f6db364d04e"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a7365b77740e6e46103a721b8b0b5abc4d32acb51c4c5c519db9f6db364d04e"
    sha256 cellar: :any_skip_relocation, ventura:        "3a7365b77740e6e46103a721b8b0b5abc4d32acb51c4c5c519db9f6db364d04e"
    sha256 cellar: :any_skip_relocation, monterey:       "3a7365b77740e6e46103a721b8b0b5abc4d32acb51c4c5c519db9f6db364d04e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a1beb94831683e8e41656ea013437c7e63c3ba418c6beaca6aa02d0985af9c0"
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
