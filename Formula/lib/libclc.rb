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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c72cfb38ae7600500cca07310b9177cb8f29272afd28a42906d112b79f5ff52d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c72cfb38ae7600500cca07310b9177cb8f29272afd28a42906d112b79f5ff52d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d65d0bf51091cc53fcf4e8613fe5d467b359d665b7ff26b9ce76ddfa7092bc8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5af04b2231526463ed44a17f076c1e84b98f71ebf5c82c90131b609d2be88fab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1c4f6090c89d999ea603c8e82cc6a2e2615ed5de7a67a332135b113b61956422"
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
