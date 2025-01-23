class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://github.com/elijah-potter/harper"
  url "https://github.com/elijah-potter/harper/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "48510bda9d38836ea4f562a11e0a621e328db554dfc929e3533a198fe8b63d61"
  license "Apache-2.0"
  head "https://github.com/elijah-potter/harper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22bc0dacb535ac5568b3e08d319863aade28c73e82aa858486c77a97675c53f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b28c8d63ff5aa2913faf29d12a676b1f03b136faa8147f9f3562dc44d277f74"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b748b16bbe9d502fcf6edaf98ab4554eb8e847802b625a34c02eea84ac3cb0a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb5220d3e314714f806bc7e131bceeb6a745a7adb1ed86796bfd053221816504"
    sha256 cellar: :any_skip_relocation, ventura:       "305970f0fbae477aabf1b28129e5c82b5586b666d09d1200214b544797a6749e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f586c29d1c0e1dd3d9cf1a3e3cc7372e67233fbd2be2707638b3142a6bcb5f5"
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
