class DesigncraftCli < Formula
  desc "Headless DesignCraft CLI and MCP server to script, export and validate layouts"
  homepage "https://getartcraft.com/apps/designcraft"
  url "https://github.com/storytold/designcraft/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "6c422a7bb8db1ac8acec20586483231944e174f093532a26e66e3cffd5317b31"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/designcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "03cded827dc1f0f729fe6e86eea922e8bc1d4478f728b46d5ce7a2df725dfbf9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9d515255d33ea6dca68e4732e46872d71a12f748e084e020652c41dd82a0e204"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ae362b2c3c65a030988832aa88250fe3646137906d2c989cc6e71362c2a89166"
    sha256 cellar: :any,                 arm64_linux:       "9ba99b8ec26fd106c66c9355687964cfd328d52dd1abb574f43ad0d9b67583c0"
    sha256 cellar: :any,                 x86_64_linux:      "b6369b093da0bf66b652acb861c1a480115b02a243b1e6ea43e330e839cddf38"
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
