class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://writewithharper.com"
  url "https://github.com/Automattic/harper/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "cd25a085881ddabec32783c6cff4293489ef2e444d73e25b926874df61361b13"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a8f3dfba276dcca8c28caed4d3f7b1f4c92cd13525ed096dbdb23f12fedee6dd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a54aacb61f76f682794a9aa65512734571183d4c242c494f22b3b0783bfcd979"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dc307424dab7803fa672c8fd5d11fb3d9e3bee77476523369ef44a2f3b5e8666"
    sha256 cellar: :any,                 arm64_linux:       "ded05f2e77b2cc89811634f3bd46b748b85fd182caf774bac66ffac2713eb607"
    sha256 cellar: :any,                 x86_64_linux:      "9253ee9ce038e1b809c49f4bff531b80f3b55db90acc11a84fb8f1445e09ffcd"
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
