class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://writewithharper.com"
  url "https://github.com/Automattic/harper/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "c8f1c96401a5f5664d36b7d7babebc5ca6e14b318146c27e918d4e9ee950b133"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fd8f8ad47d678ffe8a5aca58f750d6597bc34cc8b0037eb1d24da0c4ab9a8f4a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2a1cabe98079bc0e323566cb2d2fbed604716aa49a956c8d99328bb2134ca281"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5ffcc8f7486cdaeb1800b5ed48296b559e5923085979858c486bf3d171dbaa13"
    sha256 cellar: :any,                 arm64_linux:       "c29ec18b9c88630f5a63eaa5232c44f40d8efb710375ca2102ba0be84b4fcd6e"
    sha256 cellar: :any,                 x86_64_linux:      "1aee3219e88419d8554628fd83e0eb3dbf7f2a655906ac9a5de63bed6d007b8b"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
