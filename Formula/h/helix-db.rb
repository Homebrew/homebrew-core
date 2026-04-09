class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://github.com/HelixDB/helix-db/archive/refs/tags/v2.3.4.tar.gz"
  sha256 "9e18fca307763d13798332507adbb19d2fc1ef77d2fc022f3be01769d4ad47c3"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04ba6df0ab32b8743bc4a88e90c68164b99c3cc80b09383850f63ca431f3779a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29077fc0125cb6a7eddd23bf197ffdb9df8e22823bfdf1e3faad95cb39a4247d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37db147e17cfb316f2f86977b6268b0d092b6b8b84de0b466678c5dabd639643"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b8377a99c121bf9f84548f8d7ebca60e447b0f2ffca5e7f1eeb6ce37e6a1d10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "712acc409087490443bb52a562fa7df17971e4ed8f52be0ad1cc455db18702db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e541ada036d3f575c97480c75b0452a5ddb47394cfffd9676b9b67000e10449"
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
