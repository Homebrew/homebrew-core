class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.4/libclc-18.1.4.src.tar.xz"
  sha256 "81e687138a35eeaee70f0fdce4a7a892b94e3c0f310e3f0efa640efd0af2c29f"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c22a70ca9e09145dfefdeec308810e8f6b257d696f26ca892e1a7e2fae968ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c22a70ca9e09145dfefdeec308810e8f6b257d696f26ca892e1a7e2fae968ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c22a70ca9e09145dfefdeec308810e8f6b257d696f26ca892e1a7e2fae968ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "7c22a70ca9e09145dfefdeec308810e8f6b257d696f26ca892e1a7e2fae968ce"
    sha256 cellar: :any_skip_relocation, ventura:        "7c22a70ca9e09145dfefdeec308810e8f6b257d696f26ca892e1a7e2fae968ce"
    sha256 cellar: :any_skip_relocation, monterey:       "7c22a70ca9e09145dfefdeec308810e8f6b257d696f26ca892e1a7e2fae968ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b956a19249dd578287a233974efdcb7fa2b42c7369f199085fd6b7452a192449"
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
