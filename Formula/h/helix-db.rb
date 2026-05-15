class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://github.com/HelixDB/helix-db/archive/refs/tags/v2.3.5.tar.gz"
  sha256 "79d5a19efacdc1ee20f74eacdf26e738e1e8a5191de4e86fad0444857ce3d2d0"
  license "AGPL-3.0-only"

  bottle do
    sha256 arm64_tahoe:   "18235fdcfab03d6a82530e186ef69796e23883a0886041ed01c74cb9b12c8b88"
    sha256 arm64_sequoia: "9a3761517c7b0ca78f9d95da176c13e21135c5b4c11e6cecd9ca59b75a9e879c"
    sha256 arm64_sonoma:  "1179e76b2664bd8129f43f157a3b10895597b50052516b0ab3a49a1f6cc1de9f"
    sha256 sonoma:        "e28c0e6a81831a7cc19e0383ad8607b8c2ef0791aec373d58ba2cb41d230b93c"
    sha256 arm64_linux:   "36c0b10740805e42bffe08b1c7e93c9c022623be2d438c1c9ed8c2f2064d3b99"
    sha256 x86_64_linux:  "6ea542bec5be53dd884f7524b88cdba08efb3998fc2eb3b21de7c4efcddf3a92"
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
