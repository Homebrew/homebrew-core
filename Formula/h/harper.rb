class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://writewithharper.com/"
  url "https://github.com/Automattic/harper/archive/refs/tags/v0.66.0.tar.gz"
  sha256 "5572a64abd40dd63dd8d6487e0a5ae71f8eb40809e609c4626b0d578647ca0a9"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f394cbba925e8cdd3d72e36fa9c70b62ce220ba055afd2b68f0b5a7db74de480"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "999768d9ddea3382942d99e785a5fab03771da6622d1b4699223b02e333c6a44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e42969aa9e4127486a8a080f0e807a2dbb06cd7b92dbe997238d08b08971ff0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e3bf57f2e6c8445fd6e92f54e989a0e0c69a2c434bd038fbda00b4c365caba6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f148837b319131c1ad638119da9a2a4a3442702f6b57a151e94ab59d6c81b3f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4a2ad9e3ab63bd3a12c84e2634e41a870743dda930850f9dc9f1b87ed4b675b"
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
