class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://github.com/HelixDB/helix-db/archive/refs/tags/v3.5.1.tar.gz"
  sha256 "0b76b4a7afbdcd0385b3a18c78218fa8afb9e99d68d2d16618c09593e0819855"
  license "Apache-2.0"

  bottle do
    sha256 arm64_golden_gate: "c3698ed070f4ba3e7c64369ea9a89b00acb149b367eef0d40f2310bcfe20e017"
    sha256 arm64_tahoe:       "d583c3921a1a0decc004413d470f3cc974739ce005330a7f3af119da9b64dac9"
    sha256 arm64_sequoia:     "20a1a04083b74315c4306d50e9b8f64df2cc2fc1425d6ac6e07c6f2e954f6688"
    sha256 arm64_linux:       "d08ca5ab41328de63a1ffccffc907af84814b86cf09030de6e7c215c3dd9cf2f"
    sha256 x86_64_linux:      "44d5017605a67ef1e133292f15fd3878c0e0c917fd0be543d70a636b9decb5a9"
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
