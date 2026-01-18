class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://github.com/HelixDB/helix-db/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "db5b63e8f63e27ee9739758dc48f632ea13329d2a087ee47527dd5594191830e"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd77478ac34e4f8072d8e71a5eaecdb6dc6fd0f02308cced66ffbb166bd18022"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6347c9b3e81dec96f798301ac24d28b8118e96756a7f6e595693b96cce8d3101"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d95e9dad3b6eaff0e242a3019afcf22a56d4fd8c4e5359d60415b6e0eea74c9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "305588c03a9fa9fac5e63965e271767f12bd7ef5b2c1df30e9e4fcd0928a3500"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d13b5cd94a1a700b91d3b79a211a31745e0b37c2c8c4cb572253449d7816edd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac45be2e8574804ba6d74835adaaa4c3a3e1705485cc34d5c58d8e170b6f5fce"
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
