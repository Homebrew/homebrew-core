class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://writewithharper.com"
  url "https://github.com/Automattic/harper/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "c2576a84a81019399095eb1bdbd0b66a32a1dba780ff1dea2b3d083e8b20626e"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "71738c5cb03fcd80c1c43a496420ec9fe18d5e463156604af576f346579bd490"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f7170730fd5c766b29358c5cbed1d1b57167b2ed2440471516f72f35eec4ad1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1ad4c26eb17e614fa025b4adaf2d7c73e79b949fee082fa0aa91e81a464bbe91"
    sha256 cellar: :any,                 arm64_linux:       "eaec65356c96f22b75326404ebdfa1bae70f80aa7269544b1e3d6d2f15ef4c43"
    sha256 cellar: :any,                 x86_64_linux:      "c20d92860209b5b432e7bb983fa566389e7dd9735c22faa2f3ffd2384679de46"
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
