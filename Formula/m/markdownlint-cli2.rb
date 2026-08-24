class MarkdownlintCli2 < Formula
  desc "Fast, flexible, config-based cli for linting Markdown/CommonMark files"
  homepage "https://github.com/DavidAnson/markdownlint-cli2"
  url "https://registry.npmjs.org/markdownlint-cli2/-/markdownlint-cli2-0.23.2.tgz"
  sha256 "b957e784d84c5ff2665f318e13cf00c1e7072016e315057f6917b7eb01ab6d09"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "86fad7597b1606a6cd4b90e66f5decb4a53d817d550442187ae774ce1a7b95e9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"test-bad.md").write <<~MARKDOWN
      # Header 1
      body
    MARKDOWN
    (testpath/"test-good.md").write <<~MARKDOWN
      # Header 1

      body
    MARKDOWN
    assert_match "Summary: 1 issue",
      shell_output("#{bin}/markdownlint-cli2 :#{testpath}/test-bad.md 2>&1", 1)
    assert_match "Summary: 0 issue",
      shell_output("#{bin}/markdownlint-cli2 :#{testpath}/test-good.md")
  end
end
