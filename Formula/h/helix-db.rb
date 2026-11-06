class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://github.com/HelixDB/helix-db/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "db385547ea8945046924962f0448a0769f06807a38e8ddbd87d7b6d2b0fdc123"
  license "Apache-2.0"

  bottle do
    sha256 arm64_golden_gate: "488d30986f13d9f13da95fc31260d7db63e64b40a6e3eeb50c8cdeffff6836d8"
    sha256 arm64_tahoe:       "5b9f4570bb565e91c50060fb0564542f5cd7dd4b763b06b3a2778a4d3168eeb9"
    sha256 arm64_sequoia:     "e10c64829332c1867575473ba60dc74c71867f7e88a9876d0490725c8096250d"
    sha256 arm64_linux:       "c5ad5564cdef357be76192352a29691aad4945608b2963b1b17259c8e292aee5"
    sha256 x86_64_linux:      "62ee42d656101859a37c40feab8d1e5b27573a8f10e9a0af171eb7cdff322a7e"
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
