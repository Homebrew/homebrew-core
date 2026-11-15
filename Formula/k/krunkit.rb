class Krunkit < Formula
  desc "CLI tool to start VMs with libkrun"
  homepage "https://github.com/libkrun/krunkit"
  url "https://github.com/libkrun/krunkit/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "ce714476e62db927cc872e4d2f066f5f756f6f54fef2f0cc4fc82329be75c86d"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "4c4d642f464057ca963cd9c2052084c41ee9bf083647bb91237aa31dc5ae86cd"
    sha256 cellar: :any, arm64_tahoe:       "4903df907de9473730db8039a8e737ec25422413831f2aba484abb9a87335a5c"
    sha256 cellar: :any, arm64_sequoia:     "9c296146afa55c183290349e869d6e9f712e83cb2aa2e9a91ec0df6f9ffef0d2"
  end

  depends_on "rust" => :build
  depends_on "libkrun"
  depends_on :macos

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "edk2/KRUN_EFI.silent.fd"
  end

  test do
    assert_match "krunkit #{version}", shell_output("#{bin}/krunkit --version")
    assert_match "vcpus must be a minimum of 1",
                 shell_output("#{bin}/krunkit --cpus 0 --memory 1024 2>&1", 1)
  end
end
