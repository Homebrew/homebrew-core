class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://github.com/HelixDB/helix-db/archive/refs/tags/v2.2.5.tar.gz"
  sha256 "6229ce5c5fdf7cb056a1eb31ef5aa1553ee974fec1e2c5723a3679fdd0a1912f"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18886cff74fddd517b51f473c45f213ba730c0d2370d3dcb132926646e79f3ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86ba4d73e859f1bb6ef6b1ca3f2c557020f38cf149d2d50f6205ccbb33f2cd23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5da7992500b9ddd97fcfa959f0ac259951e312db9323ee21c930865b6ecc99a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e29c74418c082397a64f373e1ae7c0194c431d9aec53b9384d7aa4d83a6a9cdc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd1286d220c748aa54b885bf89083b28db1c5db66acede4dfa132e4566d4e99e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "217e7dbb22d59999282e4172cac0f578bb20f49fda8ec9ed6f434a69ff0f25d2"
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
