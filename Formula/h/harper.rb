class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://writewithharper.com"
  url "https://github.com/Automattic/harper/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "9cd55f642eb17c2a1c7e8bfb9f958fe5ea165ec98264b7ce568bedbc32dc8b18"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8df1f2f59d132a5a6ad0179a616539af57758c3d3122ea317d26a75344d62be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcf4d14cb83879a46bab9e1936fc025c9432bfd623f772777ea8d29372328009"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7326fc9b7108bc29fe1dbfb0a2ae568c6f3a3eade606a4db9735fe83fe6a5209"
    sha256 cellar: :any_skip_relocation, sonoma:        "5393def18593c78a775f117004dc55fb8f2ce6f8cf3fe6e672b80ec4e373432b"
    sha256 cellar: :any,                 arm64_linux:   "b77794cc36e01e64ce263ae831d9e8c766b545cfedf72c018a6ca9e9a5e5bc0b"
    sha256 cellar: :any,                 x86_64_linux:  "ed8b2b4d729f83fc45e7b89c61764a2cb815ef1875a7067c29a1a88adbd369ff"
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

    # Dialect in https://github.com/Automattic/harper/blob/833b212e8665567fa2912e6c07d7c83d394dd449/harper-core/src/word_metadata.rs#L357-L362
    lint_output = shell_output("#{bin}/harper-cli lint --dialect American test.md 2>&1")
    assert_match "test.md: No lints found", lint_output

    output = shell_output("#{bin}/harper-cli parse test.md")
    assert_equal "HeadingStart", JSON.parse(output.lines.first)["kind"]["kind"]

    assert_match "\"iteration\"", shell_output("#{bin}/harper-cli words")

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
