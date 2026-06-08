class Bpftop < Formula
  desc "Dynamic real-time view of running eBPF programs"
  homepage "https://github.com/Netflix/bpftop"
  url "https://github.com/Netflix/bpftop/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "a81bcc69a697ffa0919d63394d914d4b1f15b2ba33d2c28e6f6dae2187f59a5a"
  license "Apache-2.0"
  head "https://github.com/Netflix/bpftop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "fb03dc650d61c112cc50dbaccb34a6458226b1420ac7074c543436a3542962f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9644118483911436ac97875fec66ed2c85c8a92c7f50baf0d5cb057dfcde21cb"
  end

  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "elfutils"
  depends_on :linux
  depends_on "zlib-ng-compat"

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
