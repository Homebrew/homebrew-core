class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://github.com/Automattic/harper"
  url "https://github.com/Automattic/harper/archive/refs/tags/v0.73.0.tar.gz"
  sha256 "72b67b6a7d08dd782439f801f22dda70dc2c4f17176e9f3a144af8813671fdd1"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74daed77a90bca667912a754821012b32c35321031362f1b1d470491c1d6180b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "628d11b75406a99c319a56f7b1370aa6ad827ad2283649f913259e0d35ebc1d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a623de9f2540230018273558c3bc3704e54888d6d2fee80a901c17513b6bf8c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "1325934b4153b43c749acc523f26e1445b0fbaddb363f7a0a9182eb1d81aed5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3baeb5f969e3ed240248b88535b5b5e434720ea0b5b365bb257906bb86960f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7e626229c4255cfb542503a4e987537df41f7210063d61f5e58fc2e706bdea3"
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
