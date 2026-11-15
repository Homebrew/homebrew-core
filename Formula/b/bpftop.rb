class Bpftop < Formula
  desc "Dynamic real-time view of running eBPF programs"
  homepage "https://github.com/jfernandez/bpftop"
  url "https://github.com/jfernandez/bpftop/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "0663eaeda6999c248efd4f15e3a176f60a705dcbafdfc52dedacc12d770c088b"
  license "Apache-2.0"
  head "https://github.com/jfernandez/bpftop.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_linux:  "bf83b22dbd360b168b04a94e9e840ed25812881d1cd0dd471ab7c6661211f8df"
    sha256 cellar: :any, x86_64_linux: "bb886362785d2f3234f08500df78f3321aeb35115bfbec91e07e9a57f5ac677e"
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

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Bypass Homebrew's compiler clang shim which adds incompatible option:
    # clang: error: unsupported option '-mbranch-protection=' for target 'bpf'
    clang = formula_opt_bin("llvm")/"clang"
    inreplace "build.rs", /^(\s*\.clang)_args/, "\\1(\"#{clang}\")\n\\0", global: false if Hardware::CPU.arm?

    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/bpftop 2>&1", 1)
    assert_match "Error: This program must be run as root", output
  end
end
