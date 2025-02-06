class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://github.com/elijah-potter/harper"
  url "https://github.com/elijah-potter/harper/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "257310c97cc757117c7a9ca59d5bc3cfa4c229f0ec433ebc241d487ad6847645"
  license "Apache-2.0"
  head "https://github.com/elijah-potter/harper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27ecc575eb0d9b9a2cf8ad8d8508974d8f26f9c40e3a7b37dbc7b9e2d9fb15df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4832d43a72a5eb9f8020b903acf98452765ddf9b2e5b1ac02ed2b5dcc33de0b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "61fc3f55f2c952e67006ab279d2b75ed9919ea89cd6b750f97a755bd7d0a6954"
    sha256 cellar: :any_skip_relocation, sonoma:        "7588a6630c8b6033c2c6fd33d0c3140faf4a92740da219580cb601f6f8216a07"
    sha256 cellar: :any_skip_relocation, ventura:       "d9c1748088b366d962f410563b2527ce59c6eb130dd24fffb9c1994fb056bfa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "641b178ac8281a6fc29040527411c912211e776224220bd9418ba72182966d6c"
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

    system bin/"harper-cli", "lint", "test.md"

    output = shell_output("#{bin}/harper-cli parse test.md")
    assert_equal "Word", JSON.parse(output.lines.first)["kind"]["kind"]

    output = shell_output("#{bin}/harper-cli words")
    assert_equal "B", output.lines.first.chomp

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
