class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://github.com/HelixDB/helix-db/archive/refs/tags/v3.6.2.tar.gz"
  sha256 "5105df39d58c698044ca83871ec03da58a94362ac19400140a00962a311bcc9f"
  license "Apache-2.0"

  bottle do
    sha256 arm64_golden_gate: "f9b430e2ff2526594fdd7f54a70dc6dd5d6ef8ddd902eb243db42949ae9b68a2"
    sha256 arm64_tahoe:       "688785d25316c52170cebbaed7b0f72b2674117b529ae04b7faf4284796e1cc9"
    sha256 arm64_sequoia:     "09aac96adc98772170e2ddcaf09e87a080b3f6b0b87e66d431055206d242b01d"
    sha256 arm64_linux:       "24d3d14c8c8f02abb0399c9277cc2fda228a5a6f4e1c42b80ce9cd26ec88129e"
    sha256 x86_64_linux:      "f414ef228821b31378dd5bca3e7d2b9301edc4015c2a6ce237a43adaf79ffe3e"
  end

  depends_on "rust"

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
