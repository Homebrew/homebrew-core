class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://github.com/Automattic/harper"
  url "https://github.com/Automattic/harper/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "8ee8c8e1da56d227d70e4cb4bcb78699e74ebb33030d4d8985c4312c28a7e6a1"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd512f68b2dd0403553fc36c694825342250c504cd98927f36e2682ac59c16b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "050cc27d0f648be6fe4a177bbdf5c3ba9d877bb160b10bccf766a3c94b143a29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fc34c37b8ecfe9c873444f820a7335c655764edd4e5a43b9aa93d3a2aa44d51"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed1206d21481dbdb08ed5ed9a36750bfb9eeb8256918b563535ea99d658ff63d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c3d396ed030976ca3c29206b51721d675cee707430836ad0948b4d2ed8510a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cb177cd81b90bbc0c9a49d8dfaae48cfab63577fd1b7075ad2df6ba993d1503"
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
    lint_output = shell_output("#{bin}/harper-cli lint --dialect American test.md 2>&1", 1)
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
