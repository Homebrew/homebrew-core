class DesigncraftCli < Formula
  desc "Headless DesignCraft CLI and MCP server to script, export and validate layouts"
  homepage "https://getartcraft.com/apps/designcraft"
  url "https://github.com/storytold/designcraft/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "77a1ad63f00deaa2bce92ee4399af763c7344806d20e4f6ff07e9b51cb491330"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/designcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "686b6a8b908554f79d9b492ba6096746cd9e1a468c3c24d8b955ca3a282c862f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "efa9b064b96944f580ba184a525aaf027fad1fd50b0b5d1abb25070cdacbcc91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "862d22d3ee7bb4355248d2b21d468d77b08f05add4a7f9a35dc727329768b449"
    sha256 cellar: :any,                 arm64_linux:       "654514312696481c9529db7bfafd998042fec90aac2ae089a24c30c0a12e10b5"
    sha256 cellar: :any,                 x86_64_linux:      "dc3743a318135deb1bd00aac52b85f4818f2f395463809120fb61ad36c49b05e"
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
