class DesigncraftCli < Formula
  desc "Headless DesignCraft CLI and MCP server to script, export and validate layouts"
  homepage "https://getartcraft.com/apps/designcraft"
  url "https://github.com/storytold/designcraft/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "2648d4b58bf397985a70c07c785ff0342c9dbda30e614eae23d880d65a875589"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/designcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "405caf86e9ff523a4132a0321a7fa8bc5181806f69acfcc60a4b731004d8b2d0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2835a4111cb1f4875cf52ee3a08a3193f3d39f1be93e870fb02c5742b4719158"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fc835dfdd1d339040629fe878a722305508341ccf44c2ae6090438ce03276386"
    sha256 cellar: :any,                 arm64_linux:       "05144f0862096123296f9d442c0aff459bbddcafd57e691150b6cbfba22cd6d1"
    sha256 cellar: :any,                 x86_64_linux:      "dba9c6955cca82ceecefa2893c14fe482ac307d6fd41797ae2a91b5b74888c34"
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
