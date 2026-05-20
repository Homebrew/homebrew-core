class Aliasman < Formula
  desc "Terminal alias manager with semantic search and Claude Code integration"
  homepage "https://github.com/adityak74/aliasman-mac"
  url "https://github.com/adityak74/aliasman-mac/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "650d2a12515cd7422bdec8a6b96f2daf99ebad39e2c2be989cd5271e66f1418d"
  license "MIT"
  head "https://github.com/adityak74/aliasman-mac.git", branch: "main"

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aliasman --version")
    assert_match "Usage:", shell_output("#{bin}/aliasman --help")
  end
end
