class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://writewithharper.com/"
  url "https://github.com/Automattic/harper/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "6abc9d0ae180da80b1862a980ab6258cea85daa21c2ac35b5fc65e44b4d2a10e"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad26b0d31afc1eb923d9e4e8b273ca3cb4ac4264d0d02482c57ff45cc1009dcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63308eeeebadfbd021dd2e458f045c8fa3843a903d1321c987f3e594293e0137"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "23904d34d8bad88fc3703a944f6c217822673980e77c6819acdfa88ef3af2cc3"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d0d25be7d6d0a3aea17dcee768a378c0f836a1c5bd89a7c8e79f6c881fa7d36"
    sha256 cellar: :any_skip_relocation, ventura:       "bdfd494775a5a1a160330e1884ceb73d38d4d61782b8b3550e33ae156b96f64d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0f0d152cd7b6f8f35386e4dce79b87c316e446ab170288c7ee2bf8c079cdb0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb733fdf412ffdbe11994fda7c6b99f4940851b7d81d887231dc81219ad5801d"
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
