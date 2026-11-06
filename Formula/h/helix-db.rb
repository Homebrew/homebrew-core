class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://github.com/HelixDB/helix-db/archive/refs/tags/v3.6.1.tar.gz"
  sha256 "d68e08f3f01c9e716ca66e870a03815a909f8b413e646a7c34454e4b82666122"
  license "Apache-2.0"

  bottle do
    sha256 arm64_golden_gate: "bd5888026880ef166ffa89bd1d03ce05824128ec21bd52f7d25b41d743bda044"
    sha256 arm64_tahoe:       "8ed9db7e987e6a6750520f26300203d45a892d153a400eef6970bd65bb708288"
    sha256 arm64_sequoia:     "19a11287997ea8b4770856b09d71b7efb42bd9e8e6840f7b8e93477d419f4897"
    sha256 arm64_linux:       "1ed902899485bfc48f9da568eb2cfffa27f6c8be8c4c4f682ccf87ce29a487d8"
    sha256 x86_64_linux:      "f4aecc9ccb00e4386fb1efed9e1339b0a9080fd44ce3e2eae9d3a2a32b442bcd"
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
