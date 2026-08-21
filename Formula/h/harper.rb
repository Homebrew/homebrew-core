class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://writewithharper.com"
  url "https://github.com/Automattic/harper/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "00acec037c8a50021665ba7f27e0a46a4a8a23357a0127d7d2531ca32c8a7333"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b776d4e02368d1b540d58355bdce17f10dfa694ada671b214c7bad7664aa7e9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "994f9e18413a693a231dde90400de604f8dd42126c035b92b12948a88f72ca7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f13f0a7a99f439384baf510fbd830c618f13e9b86dfe45ac0878866b7eb823a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "411df8b1a9534b035b48f8421537e64bdf76170a489c32c243733fa2f8010df2"
    sha256 cellar: :any,                 arm64_linux:   "c601d88570e8db5536c5e133d260fd53745b54ed3d07c9d2d58b9bc9982b70ed"
    sha256 cellar: :any,                 x86_64_linux:  "f937b8fec3560ca785c10ed447b31c7aad326c69cddba6c48f879d4cbc3703d0"
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
