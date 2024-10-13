class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.1/libclc-19.1.1.src.tar.xz"
  sha256 "2872099fab914f02dfaa3fd42767b93fbcc6027289433c5263d693f5fd73e189"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "877fc0af3b273f100d56cb3598c2985db33794e5b0a53cce9ec390c96c059b23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "877fc0af3b273f100d56cb3598c2985db33794e5b0a53cce9ec390c96c059b23"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "877fc0af3b273f100d56cb3598c2985db33794e5b0a53cce9ec390c96c059b23"
    sha256 cellar: :any_skip_relocation, sonoma:        "877fc0af3b273f100d56cb3598c2985db33794e5b0a53cce9ec390c96c059b23"
    sha256 cellar: :any_skip_relocation, ventura:       "877fc0af3b273f100d56cb3598c2985db33794e5b0a53cce9ec390c96c059b23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7714e70361b0b7af7d914f049f20dd358831b5e68d7a97ad74340217f11b290"
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
