class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-22.1.5/llvm-project-22.1.5.src.tar.xz"
  sha256 "7972b87b705a003ce70ab55f9f0fb495d156887cba0eb296d284731139118e2c"
  license "Apache-2.0" => { with: "LLVM-exception" }
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70b97f6b3018bab701dfed3634ca890c463ba5a3445436a92e3f41fdc90c2e87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70b97f6b3018bab701dfed3634ca890c463ba5a3445436a92e3f41fdc90c2e87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70b97f6b3018bab701dfed3634ca890c463ba5a3445436a92e3f41fdc90c2e87"
    sha256 cellar: :any_skip_relocation, sonoma:        "70b97f6b3018bab701dfed3634ca890c463ba5a3445436a92e3f41fdc90c2e87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70b97f6b3018bab701dfed3634ca890c463ba5a3445436a92e3f41fdc90c2e87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ed31599ad9b3fc539dca989f92aafe23ae6b5a890fdd9c74601baf7842594e7"
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
