class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://writewithharper.com"
  url "https://github.com/Automattic/harper/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "c8f1c96401a5f5664d36b7d7babebc5ca6e14b318146c27e918d4e9ee950b133"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5b0c9fccc3e01b6db3b7d4e4d5a5b87f6c337de1b19068e0d9d3887fa848fb48"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b3b5141d44b945d30273feb0738d53038cc91e9a584859ed837c125172ed355c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f8cb4c59901df70ea10d05ff9136d5e0b693801ce715c5906997c1bf70ba2463"
    sha256 cellar: :any,                 arm64_linux:       "5aa08489d5143ed65bb9762d591d8da086c7907532c0aa959137c683e1e4b4fa"
    sha256 cellar: :any,                 x86_64_linux:      "0efdcd7ad9882e1dc92bec9140e0949b207f12cf5f9ca1958752c6ce8d1c0e17"
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
