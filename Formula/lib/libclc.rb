class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-22.1.4/llvm-project-22.1.4.src.tar.xz"
  sha256 "3e68c90dda630c27d41d201e37b8bbf5222e39b273dec5ca880709c69e0a07d4"
  license "Apache-2.0" => { with: "LLVM-exception" }
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7eb38566025fa64fe192763af9c852d98687294bff4265fcae913de9769b942"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7eb38566025fa64fe192763af9c852d98687294bff4265fcae913de9769b942"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7eb38566025fa64fe192763af9c852d98687294bff4265fcae913de9769b942"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7eb38566025fa64fe192763af9c852d98687294bff4265fcae913de9769b942"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7eb38566025fa64fe192763af9c852d98687294bff4265fcae913de9769b942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0635be18191854d6d21f652d95a34edd5dab6d8da021dfcd5cdea7cc1057b9df"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => [:build, :test]
  depends_on "spirv-llvm-translator" => :build

  def install
    llvm_spirv = Formula["spirv-llvm-translator"].opt_bin/"llvm-spirv"
    system "cmake", "-S", "libclc", "-B", "build",
                    "-DLLVM_SPIRV=#{llvm_spirv}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    inreplace share/"pkgconfig/libclc.pc", prefix, opt_prefix
  end

  test do
    (testpath/"add_sat.cl").write <<~C
      __kernel void foo(__global char *a, __global char *b, __global char *c) {
        *a = add_sat(*b, *c);
      }
    C

    clang_args = %W[
      -target nvptx64--nvidiacl
      -c -emit-llvm
      -Xclang -mlink-bitcode-file
      -Xclang #{share}/clc/nvptx64--nvidiacl.bc
    ]
    llvm_bin = Formula["llvm"].opt_bin

    system llvm_bin/"clang", *clang_args, "./add_sat.cl"
    ir = shell_output("#{llvm_bin}/llvm-dis ./add_sat.bc -o -")
    assert_match('target triple = "nvptx64-unknown-nvidiacl"', ir)
    assert_match(/define .* @foo\(/, ir)
  end
end
