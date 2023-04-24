class LlvmArmEmbedded < Formula
  desc "LLVM toolchain for Arm embedded targets"
  homepage "https://github.com/ARM-software/LLVM-embedded-toolchain-for-Arm"
  license all_of: [
    { "Apache-2.0" => { with: "LLVM-exception" } },
    "BSD-3-Clause",
    "BSD-2-Clause",
  ]

  # build process requires git information, so the repos have to be downloaded in full
  stable do
    url "https://github.com/ARM-software/LLVM-embedded-toolchain-for-Arm.git",
        tag:    "release-16.0.0",
        commit: "c1dbc6bf94ab1009400ec430ff0dd7f921044cce"

    resource "llvm" do
      url "https://github.com/llvm/llvm-project.git",
          tag:    "llvmorg-16.0.3",
          commit: "da3cd333bea572fb10470f610a27f22bcb84b08c"
    end

    resource "picolibc" do
      url "https://github.com/picolibc/picolibc.git",
          tag:    "1.8.1",
          commit: "93b5d5f2ad44867b60267417cd6d6250dbf68983"
    end
  end

  head do
    url "https://github.com/ARM-software/LLVM-embedded-toolchain-for-Arm.git", branch: "main"

    resource "llvm" do
      url "https://github.com/llvm/llvm-project.git", branch: "main"
    end

    resource "picolibc" do
      url "https://github.com/picolibc/picolibc.git", branch: "main"
    end
  end

  keg_only "this is a specialized build of LLVM that would conflict with the standard build"

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.11" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    ENV.libcxx if ENV.compiler == :clang

    resource("llvm").stage "external/llvm"
    cd "external/llvm" do
      system "patch", "-p1", "-i", buildpath/"patches/llvm-project.patch"
    end
    resource("picolibc").stage "external/picolibc"
    cd "external/picolibc" do
      system "patch", "-p1", "-i", buildpath/"patches/picolibc.patch"
    end

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    "-DFETCHCONTENT_SOURCE_DIR_LLVMPROJECT=#{buildpath}/external/llvm",
                    "-DFETCHCONTENT_SOURCE_DIR_PICOLIBC=#{buildpath}/external/picolibc",
                    *std_cmake_args
    cd "build" do
      system "ninja", "llvm-toolchain"
      system "ninja", "install-llvm-toolchain"
    end
    (prefix/"bincfg").install bin.glob("*.cfg")
  end

  test do
    expected = <<~EOS

      \s Registered Targets:
      \s   aarch64    - AArch64 (little endian)
      \s   aarch64_32 - AArch64 (little endian ILP32)
      \s   aarch64_be - AArch64 (big endian)
      \s   arm        - ARM
      \s   arm64      - ARM64 (little endian)
      \s   arm64_32   - ARM64 (little endian ILP32)
      \s   armeb      - ARM (big endian)
      \s   thumb      - Thumb
      \s   thumbeb    - Thumb (big endian)
    EOS
    actual = shell_output("#{bin}/clang --print-targets")
    assert_equal expected, actual
  end
end
