class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.2/libclc-20.1.2.src.tar.xz"
  sha256 "ea1db1c7ffd6ba524124112040458f033ee7a156d9e382e5d04e73d609f8fbed"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3a8cc6c750a52bf40462f2a710d20c2c9dec52064059842914795f98cfc9593"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3a8cc6c750a52bf40462f2a710d20c2c9dec52064059842914795f98cfc9593"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d3a8cc6c750a52bf40462f2a710d20c2c9dec52064059842914795f98cfc9593"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3a8cc6c750a52bf40462f2a710d20c2c9dec52064059842914795f98cfc9593"
    sha256 cellar: :any_skip_relocation, ventura:       "d3a8cc6c750a52bf40462f2a710d20c2c9dec52064059842914795f98cfc9593"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3a8cc6c750a52bf40462f2a710d20c2c9dec52064059842914795f98cfc9593"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "225542b05c46b4ebb3c2d60f515471db28fb8742239c524c4490e11e6c02533b"
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
