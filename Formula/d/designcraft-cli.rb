class DesigncraftCli < Formula
  desc "Headless DesignCraft CLI and MCP server to script, export and validate layouts"
  homepage "https://getartcraft.com/apps/designcraft"
  url "https://github.com/storytold/designcraft/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "b990dcc761c1324dcc9bbd964eec152535e2e2ffb64879958b0acf4c81064326"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/designcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0b18a1c4362a349b3cc0b25ce95d0349253d1e41ebd4c18563520fed7ce544da"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e3b5eba3db3001a569f9046d78132603951eb731c4d122579bcf5fe549cd9187"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9bb42ebe3a6cbf4951043e8bd64142c8e493113a519d84364adaaa94aa3f681d"
    sha256 cellar: :any,                 arm64_linux:       "69fe68ab65021443b7d1c7c4f50a709aa893ee4d6c3d0f50f8a6a1ee3236c592"
    sha256 cellar: :any,                 x86_64_linux:      "79b439a80ed1f982701bd2327602f4748a71744b696ea0f4bd3e0b3e086b815f"
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
