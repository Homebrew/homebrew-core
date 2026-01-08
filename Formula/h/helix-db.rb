class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://github.com/HelixDB/helix-db/archive/refs/tags/v2.1.10.tar.gz"
  sha256 "4f42fd3fb5b208eb76767076c1c71ecaa47dbcc80a4e672b03008e5ebe61d613"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ffc34ddb02018443eac441cdaeb2f7a437c448a042d876e26b3aeb5726a5643e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f73ff4722641d833644a0debd037ba1358f54c7ea1ac795288282542c151067"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d130c5175636df86f19b86b12ecbdd6c452ef98f6f34ca89066cb4b50665988a"
    sha256 cellar: :any_skip_relocation, sonoma:        "56fd9e43d6cb684859ac8bada45a790226e34de7789ac83d201276dc5b8e8d1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51ae29f4a8e352844be23979315ec5ab2d5696424d71e79c7ed7a7fedc14a9de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ac4a19092115426443ac3b839dab285cd255b3749cef82e7b7987a5960a30eb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

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
