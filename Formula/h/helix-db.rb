class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://github.com/HelixDB/helix-db/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "21511da7f2c163b121c2b7dc9f0ae27b8f75179b366710c376a67cb7d36b8d75"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52c4143347381710fb8a096c713064aa481ecbdf3ed3798425a2f16f86f62228"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e4216afc663e31ba6e5a21866a2ead689d8aedeef4518bd439d072b6ce3e456"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0491f2bf35ffb8b9a61a2d981d5c1b01798dd91970cf05a41019adde8c360e81"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac4b66a753aae4e4d577d1e82428c3ed60acfee7e273927c9298766da7140fa5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aea08efc76492d9b9eaea6593078c69744034d2d5497b7ddb9e40d8944049eb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "441f59604e7cb336407b8bb9440fffa9dabfedd3f5f691a3d2029a384dbf3912"
  end

  depends_on "rust"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "helix-cli")
  end

  test do
    project = testpath.to_s.split("/").last
    assert_match "Initialized '#{project}' successfully", shell_output("#{bin}/helix init")

    assert_path_exists testpath/"helix.toml"
    assert_path_exists testpath/"db"
    assert_path_exists testpath/"db/queries.hx"
    assert_path_exists testpath/"db/schema.hx"

    assert_match "Added '#{project}' successfully", shell_output("#{bin}/helix add local 2>&1")
    assert_match "already exists in helix.toml", shell_output("#{bin}/helix add local 2>&1", 1)

    (testpath/"db/schema.hx ").write "N::User { name: String }"
    assert_match "error: helix.toml already exists in #{testpath}", shell_output("#{bin}/helix init 2>&1", 1)
  end
end
