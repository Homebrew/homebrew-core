class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://writewithharper.com/"
  url "https://github.com/Automattic/harper/archive/refs/tags/v0.65.0.tar.gz"
  sha256 "f62e8787cd83eab09c01b1c7845d2729193d9b72a7594b869c0724c54209874e"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d008c0cc6eb1d3ee711a9824851727a7d60aa4e2015f93b340752457b5d00cbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36dfbf3c7014ad56bf63390896726af172f3a54c38909f2a804eb5ddce5a92eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab2a9185093e2d45976ef0c7608994129245a87ab8dbf2e6310060e8b2e1433d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0afc40349fc2ab4fa7a4bef6e8f819e22ae86d212ea6c43f9e0af575f8916f0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04e3f201333fb982429720f98ab20c3777ad77ed96c644927005424d184fb736"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc4b918bb97ef450a15ab1fdcf3b6ae20e6a85dc7770daa7e16f6f700ab86a46"
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
    system bin/"harper-cli", "lint", "--dialect", "American", "test.md"

    output = shell_output("#{bin}/harper-cli parse test.md")
    assert_equal "Word", JSON.parse(output.lines.first)["kind"]["kind"]

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
