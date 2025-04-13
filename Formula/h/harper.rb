class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://github.com/elijah-potter/harper"
  url "https://github.com/elijah-potter/harper/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "137794c3ad67d0404870867f1b3811888be02af3870389ffa00174c3540d08be"
  license "Apache-2.0"
  head "https://github.com/elijah-potter/harper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfc62c90e20247c3c5c188a0da5103ef3132c254bd8f41e845c7e1cf98080525"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb5df689ac1626744bf66e54732a45908c60083b1d233187b09efd3da23b4408"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "01b5758a7daecf47a412ff8f041695413104bc523344d647c5d732a06a87cbd7"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ffeee43cbec442a55e8e6d95ecea55e517422c7088d5e6b672ac1904b5fcc1a"
    sha256 cellar: :any_skip_relocation, ventura:       "8b3c7a26abd5a3e973eb385b1056f27371f94c3fd9b82a76a688b6d0ad691dce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8ec1ca680d15a13838b44127678015a1845f8ed40603373c296b2dfa460384e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a94ba42afad402cc86858086055f5b776bba72231eeba9ddf3a97362874e8c07"
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
