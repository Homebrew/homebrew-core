class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://github.com/HelixDB/helix-db/archive/refs/tags/v2.2.4.tar.gz"
  sha256 "e5fa32e2b5ed9861114648aced86b249384d3e4516e513a4d271bc90d42435c7"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c83d377a3ce381c7457285fa651eab0574c92db1b5534ef155cc0b6546247bfa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2df4082ae092ac8996788efb024bb66a91f7008a8790a8912490e9ce79a7f98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a6bbdbfc5b2c0d1ed25cda0534d8e62fa0dfcac795caedae770d3f7b43374d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "6da27eed0df5b1e3897a1ff605681226b397c415b6b0800d084dec5e29b51342"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9634098b3755de695751662a6244d1fb0b27bb079e343e6ca4a3666eb7cf7fcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4eae03ae5e447c0aee69df18accac4ed156d624907018fc5b77a6fb0b10f5326"
  end

  depends_on "rust"
  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "helix-cli")
  end

  test do
    assert_match "Initializing Helix project", shell_output("#{bin}/helix init")
    assert_path_exists testpath/"helix.toml"
    assert_path_exists testpath/"db"
    assert_path_exists testpath/"db/queries.hx"
    assert_path_exists testpath/"db/schema.hx"

    assert_match "SUCCESS", shell_output("#{bin}/helix add local 2>&1")
    assert_match "already exists in helix.toml", shell_output("#{bin}/helix add local 2>&1", 1)

    (testpath/"db/schema.hx ").write "N::User { name: String }"
    assert_match "error: helix.toml already exists in #{testpath}", shell_output("#{bin}/helix init 2>&1", 1)
  end
end
