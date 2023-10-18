class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.3/libclc-17.0.3.src.tar.xz"
  sha256 "61160e3ac3841a2c27d4cd3c093961dbe58624599278a8c5a252e002f4c49686"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d6b6af33549d80d25f5d8e675894170638dea089aec51a6470770c0bc3871fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d6b6af33549d80d25f5d8e675894170638dea089aec51a6470770c0bc3871fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d6b6af33549d80d25f5d8e675894170638dea089aec51a6470770c0bc3871fd"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d6b6af33549d80d25f5d8e675894170638dea089aec51a6470770c0bc3871fd"
    sha256 cellar: :any_skip_relocation, ventura:        "9d6b6af33549d80d25f5d8e675894170638dea089aec51a6470770c0bc3871fd"
    sha256 cellar: :any_skip_relocation, monterey:       "9d6b6af33549d80d25f5d8e675894170638dea089aec51a6470770c0bc3871fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e63cdd6349b688f9bef992393fd6f0d1caf53a75b3d64f12b9ff32fcb75193f1"
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
