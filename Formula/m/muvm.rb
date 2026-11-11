class Muvm < Formula
  desc "Run programs from your system in a microVM"
  homepage "https://github.com/AsahiLinux/muvm"
  url "https://github.com/AsahiLinux/muvm/archive/refs/tags/muvm-0.7.0.tar.gz"
  sha256 "3cf9ffe550a01ed6438d1f0a4ab31a5b98af4855655f603f71a84d57e7913c3f"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_linux:  "3656663dc227a4d05ec516cbdc9c872f5062fdfa46101f4dd7a2506a44a16c44"
    sha256 cellar: :any, x86_64_linux: "0e9f1785c519d5f38c185da985cfc74128d53f69522f65eb9a4791eb321ebc8a"
  end

  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libkrun"
  depends_on :linux
  depends_on "passt" => :no_linkage
  depends_on "systemd" # for libudev

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/muvm")
  end

  test do
    output = shell_output("#{bin}/muvm --gpu-mode invalid true 2>&1", 1)
    assert_match "Expected drm|venus|software, got 'invalid'", output
  end
end
