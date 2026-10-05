class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://github.com/HelixDB/helix-db/archive/refs/tags/v3.4.3.tar.gz"
  sha256 "b61acf0a43e5c9f28f7e75375036044cbaf6183fcf1a6304673ef02af7f44b7e"
  license "Apache-2.0"

  bottle do
    sha256 arm64_golden_gate: "5f96e0a8b2465a8f4a3f4e141f70ca18319ddf600a242881ab45f5a6899e768b"
    sha256 arm64_tahoe:       "af036112429a048dfdf48692d16710a003234513dd25919d7faf1a21fd206f36"
    sha256 arm64_sequoia:     "ad83a82a120060e87c745e81d01facaccef731520f20b2475d3629f5fdfe55b3"
    sha256 arm64_linux:       "7030277dc8cbabdad76008154fa26fe15a0af9f42583003998277d256c46393e"
    sha256 x86_64_linux:      "c5ee108a1912addc7afe3a098380c081f80a2f5e255f1927f62cc7bfa37ea7a0"
  end

  depends_on "rust"

  on_linux do
    depends_on "openssl@3"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    project = testpath.to_s.split("/").last
    assert_match "Initialized #{project}", shell_output("#{bin}/helix init 2>&1")

    assert_path_exists testpath/"helix.toml"

    assert_match "Added test", shell_output("#{bin}/helix add local --name test 2>&1")
    assert_match "already exists in helix.toml", shell_output("#{bin}/helix add local --name test 2>&1", 1)

    assert_match "helix.toml already exists in #{testpath}", shell_output("#{bin}/helix init 2>&1", 1)
  end
end
