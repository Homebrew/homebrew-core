class DesigncraftCli < Formula
  desc "Headless DesignCraft CLI and MCP server to script, export and validate layouts"
  homepage "https://getartcraft.com/apps/designcraft"
  url "https://github.com/storytold/designcraft/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "d88af51773f33d1b66b8bb4858a959e99cd1ad9a39d7b7e0728b873fff21262b"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/designcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "52eeb905f8a882641ccdbe33c633b46c6fb98686132094c4e0f3df06eee9c43d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "73ed08c14a247e75f60127517feee96f22f255583fdc522a26d281f5aa16b37d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "938642aa588ba8935076cdeba6a433f8c2d1124e8d950acd166672b91a73c237"
    sha256 cellar: :any,                 arm64_linux:       "4fa838f51a49217e7599b9f854198a3ff143c780c39b369e246c3bf4da8f1c3f"
    sha256 cellar: :any,                 x86_64_linux:      "6b4fe333aba08bb787e2933c1ff04f03efe6b7476b1f896c3e660cf34dac7cff"
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
