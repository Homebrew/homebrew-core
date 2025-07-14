class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://writewithharper.com/"
  url "https://github.com/Automattic/harper/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "01f9af5e6d63b39753ec4dbc93dbd988fa123ac6de13fba9970fb09a87066484"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72a1faad1e7e24c2f08e042c2bce673c67e71cacd0516d8e0460bb01a4bf07c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5440a591f7b87faf2e163fd94f33ae63fe07809b09f200d327d60787ef398acb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eb57fbb2c5755a7550e44d387d731b24728537ec79cb1389453bb74d53052d0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "20c2061a7cd71c341f6ff32d9471a9f858d3ba92a2c4251cd4543d15aa244ad9"
    sha256 cellar: :any_skip_relocation, ventura:       "ae474e84311841a3a7367485b7f36d80655c79d152a6f57bba8a094defb79bbb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c35ab27789d1665494aa27240b3f9aa96dd06dfe2bd846ba95235db792e8972b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "908797b4d507c3aae3845620c2644c476ec87dcaa695785c7f050495ad45ad0c"
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
