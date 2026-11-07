class Muvm < Formula
  desc "Run programs from your system in a microVM"
  homepage "https://github.com/AsahiLinux/muvm"
  url "https://github.com/AsahiLinux/muvm/archive/refs/tags/muvm-0.7.0.tar.gz"
  sha256 "3cf9ffe550a01ed6438d1f0a4ab31a5b98af4855655f603f71a84d57e7913c3f"
  license "MIT"

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
