class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://github.com/Automattic/harper"
  url "https://github.com/Automattic/harper/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "70f188c5fc1e99187ddaa305d671f9c8e940b8f4368679a70866b55eea66710f"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3fdf9e800be7e297d5aec368498bc1121acd52eeed011f0479ed3c2b619be244"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a39795edea14c3b4a40aa5b0eabf8b826b5265ceed3d45abd6544b16dd334161"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95fc748e6d22a83f0fe4538d9f1064121eebd09aed36e07075b54b67c34787ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e4075022ad741aac38bf3829b131595aa07c1b13957037aaddd95231dbcdace"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6503f745dae261619725e9faaad6395147430da5054575bc27af376f209ca563"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a173f9eec8df50a280384bf5663e5cb7c742cd70322074f44ddd1cd79e1b31e1"
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
