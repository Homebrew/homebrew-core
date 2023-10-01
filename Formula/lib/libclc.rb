class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.1/libclc-17.0.1.src.tar.xz"
  sha256 "90a645ec680ac9f39acbe2aeadbdbf7e5e20cc3cce647266e4fc6c8ca11bec34"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c895f7a827b1979bbb535bf860c6e039c9fd677081f557835481bab2f43204f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c895f7a827b1979bbb535bf860c6e039c9fd677081f557835481bab2f43204f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c895f7a827b1979bbb535bf860c6e039c9fd677081f557835481bab2f43204f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c895f7a827b1979bbb535bf860c6e039c9fd677081f557835481bab2f43204f"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c895f7a827b1979bbb535bf860c6e039c9fd677081f557835481bab2f43204f"
    sha256 cellar: :any_skip_relocation, ventura:        "5c895f7a827b1979bbb535bf860c6e039c9fd677081f557835481bab2f43204f"
    sha256 cellar: :any_skip_relocation, monterey:       "5c895f7a827b1979bbb535bf860c6e039c9fd677081f557835481bab2f43204f"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c895f7a827b1979bbb535bf860c6e039c9fd677081f557835481bab2f43204f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b486a9f87837ce04269233021811dad10a06d8e6b3480276d1208d644cfdc5c7"
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
