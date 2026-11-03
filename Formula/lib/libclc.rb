class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-23.1.5/llvm-project-23.1.5.src.tar.xz"
  sha256 "fb50b1eac93ddeb3aa8dab4cfe324dff74f4a9c2bdee6160c9e36188f8d06a6e"
  license "Apache-2.0" => { with: "LLVM-exception" }
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d01bb75e1befb15fb370ba715caf5f12b338af34d0776c76db39dc63d708cd4b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d01bb75e1befb15fb370ba715caf5f12b338af34d0776c76db39dc63d708cd4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "63da17025a75cfa99964805fd86bf818d31f57b75c9c005aaf0e63ae31ffa07c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4c78c63f3bc44d009d68350f9abbda33de690cecf9d5101fc33b91d7f4fe4cca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4f3e09173647a65a61316939f59de416bc2faf20e078935f5f1070d6429c8581"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => [:build, :test]
  depends_on "spirv-llvm-translator" => :build

  deny_network_access!

  def install
    targets = %w[
      amdgcn-amd-amdhsa-llvm
      nvptx64-nvidia-cuda
      spirv32-unknown-unknown
      spirv64-unknown-unknown
      spirv32-unknown-vulkan
      spirv64-unknown-vulkan
    ]

    # Targets are cross-compiled and incompatible with shim-injected flags like `-march`/`-mbranch-protection`
    args = ["-DCMAKE_CLC_COMPILER=#{formula_opt_bin("llvm")}/clang"]

    targets.each do |target|
      builddir = "build-#{target}"
      system "cmake", "-S", "libclc", "-B", builddir, "-DLLVM_DEFAULT_TARGET_TRIPLE=#{target}", *args, *std_cmake_args
      system "cmake", "--build", builddir
      system "cmake", "--install", builddir
    end

    # Restore a minimal pkgconfig file needed by Mesa
    (share/"pkgconfig/libclc.pc").write <<~PC
      libexecdir=#{opt_share}/clc

      Name: libclc
      Description: Library requirements of the OpenCL C programming language
      Version: #{version}
    PC
  end

  test do
    # https://github.com/llvm/llvm-project/blob/main/libclc/test/integer/add_sat.cl
    (testpath/"add_sat.cl").write <<~C
      char test_char(char x, char y) {
        return add_sat(x, y);
      }
    C

    target = "amdgcn-amd-amdhsa-llvm"
    clang_args = %W[
      --target=#{target}
      -mcpu=gfx900
      --libclc-lib=:#{share}/clc/#{target}/libclc.bc
      -cl-std=CL3.0
      -O2
      -fno-discard-value-names
      -emit-llvm
      -S
    ]
    llvm_bin = formula_opt_bin("llvm")

    system llvm_bin/"clang", *clang_args, "./add_sat.cl"
    ir = File.read("add_sat.ll")
    assert_match("target triple = \"#{target}\"", ir)
    assert_match(/define .* @test_char\(/, ir)
  end
end
