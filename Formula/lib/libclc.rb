class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.7/libclc-20.1.7.src.tar.xz"
  sha256 "22b29c1a9f18d8744e5a24f36ce6d4f198d523c126cd7182569c73806e1e1854"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c07ca213a7c4e6d0b039b114e86abc0d4911583f9ddf104bcd4d7bf89dc3989b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c07ca213a7c4e6d0b039b114e86abc0d4911583f9ddf104bcd4d7bf89dc3989b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c07ca213a7c4e6d0b039b114e86abc0d4911583f9ddf104bcd4d7bf89dc3989b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c07ca213a7c4e6d0b039b114e86abc0d4911583f9ddf104bcd4d7bf89dc3989b"
    sha256 cellar: :any_skip_relocation, ventura:       "c07ca213a7c4e6d0b039b114e86abc0d4911583f9ddf104bcd4d7bf89dc3989b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c07ca213a7c4e6d0b039b114e86abc0d4911583f9ddf104bcd4d7bf89dc3989b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08ce6b6ad24a6cd69b925548d5880716c2dbea2f598549b63eb7781f86686f08"
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
