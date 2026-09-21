class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://writewithharper.com"
  url "https://github.com/Automattic/harper/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "2811d9d5fcaaee262151290f55042a9283b8d9699d18da0a52bf47a1f12609e5"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fc87d6438606d894587329a01b9d72f009a20f5182a4ce3ccde150adb0799201"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "86627d6ccf26ac09d018ef22c1133906c12078b6a688aa8e0452331c90fb3364"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c87037ab661581bb2d31f7841d318ae243c9d9886e077dd6a38e73b84e530273"
    sha256 cellar: :any,                 arm64_linux:       "1af4ffb2e52ae23a0b8fa6d6c8dae6a3cc94becb50667bfb1c64e7fb9333ac80"
    sha256 cellar: :any,                 x86_64_linux:      "b451549848760716301d3a833d2dddee34750af00d3f33e1b81017dbe8c4689f"
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
