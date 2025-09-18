class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://writewithharper.com/"
  url "https://github.com/Automattic/harper/archive/refs/tags/v0.64.0.tar.gz"
  sha256 "20976d083bc94ab6d59a60e08e5dcf9703dfe3d3cdc8fb335164d410d2b31ddc"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48d2bfe7409938d956e6a50dd0cf7e74b1ac43061a707573f8e534cc7035646b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c0989df3d23b77dec4bed16cede8770517ea13d492675f6f7f57929eb3d15e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6031b8983518cc25d4eec42ab29a98f2a19fa2b89a6583bd7a4ab9d6a474d1f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "f68dae8ea480d79a59dfccdd4d7e5ed648757ecbc4654582db415e25e7dd3038"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "596aa4e1437781f5343f900bc781d84464743ec0f6bb5af96c7c93245a90cb8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49636d3fd466eee118fe6d40ae3fdcc8a758db38287bbc57f49e9b22d01c9a9d"
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
