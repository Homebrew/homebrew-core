class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://github.com/Automattic/harper"
  url "https://github.com/Automattic/harper/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "c9ebde7b159c7491ca3350f7e1706eb7e5c105d0b790e3d2119c31e589c16f20"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24ae7049933694cca917911e53610d3e703f046115ef1679d360155fd0c2bfcd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07047ac573bb925e98c1af6ab12b6f3ab8113818ce206b77710ccce5ca19b93f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c48dac8b47f135f549c6f0d91299685b1899ca2c31f5727c59addf27a0e240d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e45beeabbc80a5351f1c7e047bebaf4edcaf03c2a4735dc8f3a4dea6a3fba606"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bb2842c9d07d440c7861040ef6b6082dc6480f46f56b2adcecf7305fc597814"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91d709fa82e293daa025ec315eb147cd002f27a5ff9f19c422ed028135bcbe51"
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
