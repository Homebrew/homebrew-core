class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://writewithharper.com/"
  url "https://github.com/Automattic/harper/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "41f71b1f73436797c17a45a5330edd58363d76dab0ff047c80d0f01a64507b1c"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2f5fc7f0f8cbcaf8df01e4726aa52440bc58cb45f2ddd613a70aea8ef6da601"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0e8aefd2ef02dd988670337a8664bcdf320038c23788afb9cd21b0c5eed1f3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ebf995c4c856c8057ccb1b6218bd598c89ccb68405127aec3e29e3efe5ac3423"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7cf00b2b275e3bebcc5545db55f85587209b34881087622f70cc00f35c27331"
    sha256 cellar: :any_skip_relocation, ventura:       "8c2d7d6d9544a5a35d8dc131aff67cabf81e4442aff431fb6b8384faec63bb86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a8bbc2cfe8d9c6eb33eb6a0e9cb7942141430d6722e8d36fac5034a29a2c6cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5c472cc996561e2f5529c077d687c6397f81d4f00755adf1719f4ae1800e09a"
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
