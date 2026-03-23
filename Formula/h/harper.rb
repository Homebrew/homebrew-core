class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://github.com/Automattic/harper"
  url "https://github.com/Automattic/harper/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "d8c45e958e3f7d61b798f6f77243a21c6f31e411920a4fce26bcb6eaa6d61114"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd093b07a8f8ea906fee86c8f5e01ab711b17aeef06c70c9e60059e32e62d9b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23b5ad00a0ef937ce05118d9b7c852179ab9f4783f43626321a0d28966e1c2e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1943f10de88d00399592b43eecfefb7426bf67bae8dd4b955c04d31faf0af12a"
    sha256 cellar: :any_skip_relocation, sonoma:        "24b9e226eef3fef60b6c6845d960565e525f69e4a04d8fa8947764f9b873a2ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea6f50b48947b8f115c5a46452b05846df2dc60895cf862e627c8da52cb9ba4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bc377f837f39f746b9893151ea34d910af2be7ac9b6d08547c9058141fa298d"
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
