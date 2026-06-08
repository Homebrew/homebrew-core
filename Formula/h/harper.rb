class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://github.com/Automattic/harper"
  url "https://github.com/Automattic/harper/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "606072412f5599bd932100c21ed22b96a280c7953941d1781e64d24ecd5c04fc"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8344e228317119a8845d9917f95f497c5166c1572054f6ccf04b40859ebfd20e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e90bd203acd83e6107b8a467f204990160089001159a4c07cf4c775fb1aeda29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d96bed1890624919b1773567e43957d35983ad0cebd42655115207b0ec66007e"
    sha256 cellar: :any_skip_relocation, sonoma:        "46cc978d34dd40e07cc0cfabd6e8f3dbcb53624761055bba9a0ccbe896169d1e"
    sha256 cellar: :any,                 arm64_linux:   "687b332a5e96c643f488db74180f19f31c666cf3c8a133da00be5dde90ce1146"
    sha256 cellar: :any,                 x86_64_linux:  "6bd6b72e80777b1a73deaa71f54a4e8a31878d5e7bebfc43130d2bef15815937"
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
