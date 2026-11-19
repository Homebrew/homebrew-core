class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://writewithharper.com"
  url "https://github.com/Automattic/harper/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "e3e4740b06622240bf4f03c7fb49916cc3e99d074358a37493a21f7489c1e0ed"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a1c069ffdf7e69538d377aa2b81b471cc954a60405f2dbb67e963a09284b7a63"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4f058327ff81bf997b4aa92a544cd26a062052518d4142a7d1335e448059f715"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b9f67e1a4a6adf3de351d54c5793f5fdbbe4b77e4003b437b796a6faa64b47cd"
    sha256 cellar: :any,                 arm64_linux:       "9a7a4b6f93a6b9fbbda10ca0b8ad3176e9c48a509472c8daf4129e22fccc27ef"
    sha256 cellar: :any,                 x86_64_linux:      "efe2bef64986d2555aad64fb9f0b3303ff2f4664b37769226ebc3b9049e1414c"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
