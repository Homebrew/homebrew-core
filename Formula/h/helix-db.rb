class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://github.com/HelixDB/helix-db/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "ce995e9669bf676a044a224930a9c94cae59155fbf9f7add2e18d56b4d51f352"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f08ed26426d1edd90b1041dddcb9a6aa2de22d59c4a2b62e0f0885a929a837a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5236b3804aa664b9b3f419bb96d26c444fd35043a7934016c972b7b4adad53b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46794e79d36de8dcc8094ecfefa4966fe50ab4fb4843fc8f4c30712be1c28a1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cf1ba706ff0f5703d3f98e841312e78a311b5f6673d71431a0c54f7fa4c3e6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "389156fd008a406f036ec36e6c22e4f76ec3af14dcf91b4c939f8e703c6e29e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae9f188499eb2de97c33117aa5d92e7ca9213d1ec6647b7a248e410819a9718a"
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
