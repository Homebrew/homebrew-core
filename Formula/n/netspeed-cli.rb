class NetspeedCli < Formula
  desc "Command-line interface for testing internet bandwidth using speedtest.net"
  homepage "https://github.com/mapleDevJS/netspeed-cli"
  url "https://github.com/mapleDevJS/netspeed-cli/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "fce853bf828868f79f395d2be92ba1f00116520d363d7eec9bf9e8b8af5b4357"
  license "MIT"
  head "https://github.com/mapleDevJS/netspeed-cli.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "netspeed-cli", shell_output("#{bin}/netspeed-cli --version")
  end
end
