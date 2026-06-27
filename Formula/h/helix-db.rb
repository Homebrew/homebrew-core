class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://github.com/HelixDB/helix-db/archive/refs/tags/v3.0.6.tar.gz"
  sha256 "e15822fbfb81acc431ace0bde54639eea2aec7d071cdaac58f5b0192d9152e8c"
  license "Apache-2.0"

  bottle do
    sha256 arm64_tahoe:   "f7d87b074ad30183fa10687b4ac9f88ebc85a47bddf6b099495b7c659ed85c14"
    sha256 arm64_sequoia: "85d9ea4e29ba3f3da80f8cdb58b371ed5d2e9dc4fe2837f0edd2389a716acf3a"
    sha256 arm64_sonoma:  "7c9f18eeb67295c519a928d4d0b224b40bbaf058ea7d687a1096d816fd0eb25c"
    sha256 sonoma:        "009822fab7b3e6630c6f343a94c301b58eef6b02df1904a90bda74c18176fc79"
    sha256 arm64_linux:   "8aec0e9f765e5616ff6263e07da2ffce71ebcc4d46865d1ecb6d95e190a612ec"
    sha256 x86_64_linux:  "be9ee9a5d2ee393932bcf048ac9a42f2ea45dfda073e758ed9d1239f16eef74f"
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

    assert_match "Added 'test' successfully", shell_output("#{bin}/helix add local --name test 2>&1")
    assert_match "already exists in helix.toml", shell_output("#{bin}/helix add local --name test 2>&1", 1)

    assert_match "helix.toml already exists in #{testpath}", shell_output("#{bin}/helix init 2>&1", 1)
  end
end
