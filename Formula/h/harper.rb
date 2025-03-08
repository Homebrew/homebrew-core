class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://github.com/elijah-potter/harper"
  url "https://github.com/elijah-potter/harper/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "0d03374ef03ef189fa3824439fb7075cf309a0284857b6d8d22107f164ad8487"
  license "Apache-2.0"
  head "https://github.com/elijah-potter/harper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89a3fc3bb0ee137a3aa5bb3de9f8a999b9e9d2dbc99364de5d7b6ec036c2563e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2ff108c632f99d5c7f28ac2fffe0865626ce0d97720ac7cf70d8ab074037ca8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "57c6a21e85eebbf1105cf5e1a0a99d1a69d0bb4fdd5b4be4b1e7ef220969f58f"
    sha256 cellar: :any_skip_relocation, sonoma:        "755dc893bc3d6a07d528d7a16b035648448b78e371a081776204056f87a06cd9"
    sha256 cellar: :any_skip_relocation, ventura:       "3eca236bd445cc600c7103f242369a19bc78e5244c874b3e26f6c0cb89416874"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3804fdb907918477f96a1d4520019b52910f1ab351036b0e1c559943b11e1fc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "harper-cli")
    system "cargo", "install", *std_cargo_args(path: "harper-ls")
  end

  test do
    # test harper-cli
    (testpath/"test.md").write <<~MARKDOWN
      # Hello Harper

      This is an example to ensure language detection works properly.
    MARKDOWN

    system bin/"harper-cli", "lint", "test.md"

    output = shell_output("#{bin}/harper-cli parse test.md")
    assert_equal "Word", JSON.parse(output.lines.first)["kind"]["kind"]

    output = shell_output("#{bin}/harper-cli words")
    assert_equal "\"B\"", output.lines.first.chomp

    # test harper-ls
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}/harper-ls --stdio 2>&1", input)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
