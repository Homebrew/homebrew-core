class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://github.com/Automattic/harper"
  url "https://github.com/Automattic/harper/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "ee05ae1000de10620d776761f6b69c78a164722a59fe601942296ff2d9c3ddce"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac4971d603861581d56d64f181711252bc8a775f38182b267caeb53db5d2bf47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "693f2020f08b639bb4bb694029f8d950f93df1797defcab0733a66c2f2df6628"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e9517fd9b8ad0adf439b554243869a775faad1c2728666ebfabbeb57e75817a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d0a5546aebbf8c17a2c8b78c6da9227e6be347af40bef8a261aff5a88c6524f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "260c9e331c9272b43d531ed01805a94bb42de3c06be484b9b0eceb504fac9669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "935378b9961158964e34cdb758ac64b383d7265a4ac8e6bf9092bba51ded0923"
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
