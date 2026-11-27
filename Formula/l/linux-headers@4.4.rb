class LinuxHeadersAT44 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/", browsed: "2026-11-18"
  # Track CIP project's SLTS as mentioned by release maintainer on final 4.4.302
  # See https://lore.kernel.org/stable/1643877137240249@kroah.com/
  url "https://cdn.kernel.org/pub/linux/kernel/projects/cip/4.4/linux-cip-4.4.302-cip116.tar.gz"
  version "4.4.302-cip116"
  sha256 "260469d3d98b0e82934734f149b99109df0fdd485b0b4fcecd1bd1db0b4987bc"
  license "GPL-2.0-only" => { with: "Linux-syscall-note" }
  compatibility_version 1

  livecheck do
    url "https://cdn.kernel.org/pub/linux/kernel/projects/cip/4.4/"
    regex(/href=.*?linux-cip[._-]v?(4\.4(?:\.\d+)+[._-]cip\d+)\.t/i)
  end

  bottle do
    manifest_sha256 "49d8bd58cb2d6a5f0ea4cee350857425d257a30570a2bca3c159a6b0585bfdcd"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "c8bc54c61dd81f71ece06e6634c502b2cf9712f1e9d70b034c6d1f0ea9491946"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "207ef524c00761a5bad4f89f66577682590d7f954d524fba0e27fac886b47606"
  end

  keg_only :versioned_formula

  depends_on :linux

  deny_network_access!

  def install
    system "make", "headers_install", "INSTALL_HDR_PATH=#{prefix}"
    rm prefix.glob("**/{.install,..install.cmd}")
  end

  test do
    assert_match "KERNEL_VERSION", (include/"linux/version.h").read
  end
end
