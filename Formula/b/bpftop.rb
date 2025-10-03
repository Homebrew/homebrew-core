class Bpftop < Formula
  desc "Dynamic real-time view of running eBPF programs"
  homepage "https://github.com/Netflix/bpftop"
  url "https://github.com/Netflix/bpftop/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "871ea55ebe1ddc9555aaf9553ecb10cbec121fe55aac1bb26d19bec23d8b597b"
  license "Apache-2.0"
  head "https://github.com/Netflix/bpftop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "009800df8f5531ace80a3b9ac23e44399679f8004bff3758b3fe4f3d8786730b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5cda56bed86048a5f27bd82a9d35e4cb8e29b3486dbfc665536af2def4e241f6"
  end

  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "elfutils"
  depends_on :linux
  depends_on "zlib"

  fails_with :gcc do
    cause "build.rs needs to run clang and not shim for gcc"
  end

  def install
    # Bypass Homebrew's compiler clang shim which adds incompatible option:
    # clang: error: unsupported option '-mbranch-protection=' for target 'bpf'
    clang = Formula["llvm"].opt_bin/"clang"
    inreplace "build.rs", /^(\s*\.clang)_args/, "\\1(\"#{clang}\")\n\\0", global: false if Hardware::CPU.arm?

    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/bpftop 2>&1", 1)
    assert_match "Error: This program must be run as root", output
  end
end
