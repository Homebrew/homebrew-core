class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://github.com/Automattic/harper"
  url "https://github.com/Automattic/harper/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "2e04700a4755194e6aac904c1dc186be5c9d32946efa0e8eeb8f8bfdfaf434fd"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d62d5f21d7f3e0992dd2a2c0feb867ff8392f20e1a322a78da09eeb2080580f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "273033784ea86f8bd0d7caa0467570b824c78537123b7df7d14f617a2a06828a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fbafc67ece82cf06cad10526b2f745113d416244c8a13daee5eab193a496e4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b264096e88c30be0c01fc82e9b44006ed3d4942cc9c24c974d1fdb2632aa28a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9ce61f476ef253f268fc69d8c5ad7908cea755f869ac7d88bf14d891e601806"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d396ee3644d09b452c969396ef34a850d8e8572af96e1861ace76fffa4175b03"
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
