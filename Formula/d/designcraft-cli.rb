class DesigncraftCli < Formula
  desc "Headless DesignCraft CLI and MCP server to script, export and validate layouts"
  homepage "https://getartcraft.com/apps/designcraft"
  url "https://github.com/storytold/designcraft/archive/refs/tags/v0.17.2.tar.gz"
  sha256 "73fde84d7142ab05d9069bdbf9929aaa4747b1ce3c6a820c3317c79f5d0653fe"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/designcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ed528bc0ddc4a90fb82bcefd44db9684e984dbe5e824cf43d4b5b082f4339056"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e448b8dabe8c6a62b7f3a9205bcd1d9717986fe3b7b063ba702eead35ecd07c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "26993fd276d196872cba9c3bb689ba9d83a4b01fa24d34df19e5d05191e3662c"
    sha256 cellar: :any,                 arm64_linux:       "eadfd53f8eb784b1032de89c167b01276024a44ca4d464ab5fc8eb987ed1f0b2"
    sha256 cellar: :any,                 x86_64_linux:      "b770f9d0f17b2bff39441ec160767a28deee632ab4b20a1c6330b34992a5236a"
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
