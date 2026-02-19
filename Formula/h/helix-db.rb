class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://github.com/HelixDB/helix-db/archive/refs/tags/v2.2.9.tar.gz"
  sha256 "978318b1e8c5d7c4dc6fc63e5dbb3a4eee021e6242407afc0d50641cf6fca295"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "294da72abfa6dcccb2a567fb284418c7fbb8c3f97b66e3c651f8169f84956132"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a662b182ef7f52bbcd40b769aec5bf7a3579307539b3e44e7c9aeb3124c6a8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07a856a9ae7fcd245a34d82dc1dc7b328eab1a1d0a09b456ee7fcfb41e3bac83"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4aa82a92ce355341ddf6df724dd3ae4a4929b8dd38c2e253d4dc27bec102da5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fd2ba14647ea8603a919538296564d6788926e8b3c2588a7015bd8a5a5dbd05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "517ba29afef296420dd51df36712205a14ad3cbcec709a29fd53a25bbd753202"
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
