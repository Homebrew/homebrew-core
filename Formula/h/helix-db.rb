class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://github.com/HelixDB/helix-db/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "1417b224a5db2ff61e9aecf7d970077ca436aa6ea68c2fe3f6e2340eaa597f53"
  license "Apache-2.0"

  bottle do
    sha256 arm64_golden_gate: "d0d98847a1c2589225ce7fedb218ae2389e72dfd1e6b08e196ec58416b4e42e7"
    sha256 arm64_tahoe:       "39301d39f9553d0707e89ac4e3855e69c9505fcb599be2e18924a6c0157e0e90"
    sha256 arm64_sequoia:     "4943c8cc938142651ed133fedce60a0ffd77255c3619fcb360a39a1a1b4ff392"
    sha256 arm64_linux:       "a661a31050a3e9263df582e9f550bac089dd6792a180dcc66176a9a3640df92f"
    sha256 x86_64_linux:      "708b938cdfc2cf769f0db1e46326c2aa7115906d2534679857e95732b43be21d"
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
