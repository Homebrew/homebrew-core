class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-23.1.6/llvm-project-23.1.6.src.tar.xz"
  sha256 "d3b86ab29cfb4445a6652e5c2642ccc75e04e38084dde3701d323320f35a31da"
  license "Apache-2.0" => { with: "LLVM-exception" }
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "78272a27582eb1ae08a7bb2e340b21f88ad50fc7ddaaf232432da79155bcc3b1"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2fdd1eb3ce7ac4e1e0daedf02af712619dd412042d470bc214c30776cbc8b2ef"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2fdd1eb3ce7ac4e1e0daedf02af712619dd412042d470bc214c30776cbc8b2ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8894656816297192e4ea6ff29f02f1ec166a05c08bf23e82ecb8f2efcffd6f5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2db1a107c7b1a6da14e41358d4ba376ab15c7c18df2249d28c8b4699e5fd8b16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6f751db9730499655c5b53ada2ec9f593f4ba0f6ef9486a9e522e69f8ac5ed76"
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
