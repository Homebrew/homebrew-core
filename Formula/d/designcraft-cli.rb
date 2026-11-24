class DesigncraftCli < Formula
  desc "Headless DesignCraft CLI and MCP server to script, export and validate layouts"
  homepage "https://getartcraft.com/apps/designcraft"
  url "https://github.com/storytold/designcraft/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "e106fde2015783c69ad420ea9a3e5a1e33fa10d7261430a3515ed3a4021ccdac"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/designcraft.git", branch: "main"

  bottle do
    manifest_sha256 "b16279de77677a8c29143fccf3d6a8b514b078cf1914f2ea113fc5c3246b8532"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0a3fd70ae5369d08b3d22df5cbef5d4746f13e2c2c829d3d42dbf28022dd02f5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "196198eec15b39defbea68ca03477c68e3dae12d03d7d11acaea1e0bd5224dfc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c73bd7c02a553d2d9207f5b959914e961781a75577bd2747288be27d30faddfe"
    sha256 cellar: :any,                 arm64_linux:       "b991447f4c2a21eb86a7c69531ddb6f8ec47bade4ed1d89ad47327c4cb4b34c6"
    sha256 cellar: :any,                 x86_64_linux:      "acbd95882e3201e1534a496f174286c5e217821f5574a01159db6559508da0eb"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/designcraft-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/designcraft-cli --version")

    (testpath/"page.dcs").write <<~EOS
      frame.create {"rect": [72, 72, 360, 200], "content": "text", "text": "Hello Homebrew"}
      frame.create {"rect": [72, 240, 200, 400], "shape": "ellipse"}
    EOS
    result = JSON.parse(shell_output("#{bin}/designcraft-cli script page.dcs --save test.designcraft"))
    assert_equal 2, result["completed"]

    doc = JSON.parse(shell_output("#{bin}/designcraft-cli run --in test.designcraft --cmd document.inspect"))
    assert_equal ["<text frame>", "<ellipse>"], doc["spreads"].first["items"].map { |item| item["kind"] }
    assert_equal "Hello Homebrew", doc["stories"].first["preview"]

    system bin/"designcraft-cli", "run", "--in", "test.designcraft", "--pdf-options", '{"standard":"x4"}',
           "--export", "test.pdf"
    assert JSON.parse(shell_output("#{bin}/designcraft-cli validate-pdf test.pdf"))["valid"]
  end
end
