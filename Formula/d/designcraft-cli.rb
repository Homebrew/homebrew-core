class DesigncraftCli < Formula
  desc "Headless DesignCraft CLI and MCP server to script, export and validate layouts"
  homepage "https://getartcraft.com/apps/designcraft"
  url "https://github.com/storytold/designcraft/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "b67858d003db4cc3324bbafebf077b3ffa7314dc37fa4cffbd190876a7a0e4da"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/designcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1d6730bdc41176c9ef7677d325df7a3ed88f93ecf8020d424816a5cc3853f5ed"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "03bd4c8d9fa23f39dbfa54633ed03a6f0f71e595576f551977825e072611ac75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c67eb2e4073860bc5b74f52c64dc636f6ce98613f353356f3c7eeec5dc80371c"
    sha256 cellar: :any,                 arm64_linux:       "6732af7da662fb0e6ac551e4fc9e9953d6e3348d1673419b057de0c356b58ea7"
    sha256 cellar: :any,                 x86_64_linux:      "0fb5fca2f5a9c87b9a0bfd6058cc9825b3a6cb4f5dd7833cc497b403c413bc2f"
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
