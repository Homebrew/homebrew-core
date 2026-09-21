class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://github.com/HelixDB/helix-db/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "e74d1ca2f3979196ec73e0e9280234280483ea3fa9511b530ba66105fa197133"
  license "Apache-2.0"

  bottle do
    sha256 arm64_golden_gate: "eabaa0daf373336008606d30d0169b5b12d2d4331af67a754168ad88222e65b7"
    sha256 arm64_tahoe:       "fc9c08dd7cd395b1fd76031948939b14ee3e36c7f955b7b2b5dfd9978ddfb138"
    sha256 arm64_sequoia:     "51cd76c9934791635fb2b4cbc636f4f280e30ba907faf587dacf66c55cf9525a"
    sha256 arm64_linux:       "1142f0f9c8928724daf83b05b16b3fcb3b9bb4fd7d459aa8962dbfd9d3acbca8"
    sha256 x86_64_linux:      "7a5d153fcb1917116a0cbcb055d1387243a6154b198137efdc3032a16f636fdd"
  end

  depends_on "rust"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    project = testpath.to_s.split("/").last
    assert_match "Initialized '#{project}' successfully", shell_output("#{bin}/helix init")

    assert_path_exists testpath/"helix.toml"

    assert_match "Added 'test' successfully", shell_output("#{bin}/helix add local --name test 2>&1")
    assert_match "already exists in helix.toml", shell_output("#{bin}/helix add local --name test 2>&1", 1)

    assert_match "helix.toml already exists in #{testpath}", shell_output("#{bin}/helix init 2>&1", 1)
  end
end
