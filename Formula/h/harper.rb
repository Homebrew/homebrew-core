class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://github.com/elijah-potter/harper"
  url "https://github.com/elijah-potter/harper/archive/refs/tags/v0.29.1.tar.gz"
  sha256 "9ac27ed81ee0b6e076adcb6b08abcc0633ba23df73d982a6f12ee6144534054a"
  license "Apache-2.0"
  head "https://github.com/elijah-potter/harper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94957468d28f38dad9cabe951a4fcdae450c8f1c9606603df6336f8d6175fd3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bba9bbaab7be82da0d18ed033a62ee69807155b475cdc96217831eb9e2d2a9a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e05d532381cda176469b0af19a3ebd31b42e62ca7ca4a3acf1b6b51f2c867d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "53e6305b271fa8d840ddc17081b153541a2603b51bcf0c6770410c280a16b59c"
    sha256 cellar: :any_skip_relocation, ventura:       "47c33eadbd6f7ad335f0d403ab511b1a2ebba159a3c52ddc73d23bac46c06b0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44d86a22c91c1e5cc6beabb50a19972a84957159af76b5f530aad259a48debe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab30120d43384579d35bb7c925d9dc922c02f1966348e6e7ca7762d330037ece"
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
