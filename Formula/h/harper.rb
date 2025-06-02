class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://writewithharper.com/"
  url "https://github.com/Automattic/harper/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "fda27384db608e183eb8a9c29174820ac316ce11e01689e798791be41da946af"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30e07f0848e6e54594e86b8b6a8fbb66cdd50db0a369d0af9b9a388edc8f57ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee4e297da99c32308e7c3636d82e33091d52acb736bb38316948c8428862b25a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d7f6affcbff78c79b67c3e83edb30aeba4e5ded287b9067596670d3db3f172d"
    sha256 cellar: :any_skip_relocation, sonoma:        "875db3cd5da0895a8f1a5eaa8f6979af9239a6ec7a1e5643e597c80b1804a94b"
    sha256 cellar: :any_skip_relocation, ventura:       "5ac7b89badfab7bb839e9fa79688dabc168a777d8b9ea55e6d6f6fa0595986ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9866928a1f9ecf257b38b42915da5171b2f5f84fe797b24262e77601d86b2a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cff2f525bcf165eb74b0c3b3fe3450cc14663102fb4cf2ef5ebfd913105b3d3d"
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
