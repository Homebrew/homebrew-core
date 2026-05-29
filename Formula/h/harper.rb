class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://github.com/Automattic/harper"
  url "https://github.com/Automattic/harper/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "44b0a9df72bac70905ef2e6a472e405bbf0233b61c00a5fce515fffc834ebc0e"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b89b7a66de75ad862410a54d349f749b913f8e88fa26df0b7de2f3b9eff94b5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e74d360d46c17eeb7b8886d631054dfd35e4774ffb4eef74c69a83588ab4c6a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de91de64cfd317720b77d846c829b7db0b9170cc086e2dd529df6ee4dba59f5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c226fc907fab3ab81cbbc2c08f463529b82ed669e787248c715dc01f28d2858"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b9d5f9472b1befaf4a8f04611839c8d3d56d37f09a8303e6038ad3a9f321f77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "984262ec1805e0dfab490ae31efe50d02f309efb4f96cf4a956fcb619d4e66d9"
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
