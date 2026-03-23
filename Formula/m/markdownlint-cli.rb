class MarkdownlintCli < Formula
  desc "CLI for Node.js style checker and lint tool for Markdown files"
  homepage "https://github.com/igorshubovych/markdownlint-cli"
  url "https://registry.npmjs.org/markdownlint-cli/-/markdownlint-cli-0.48.0.tgz"
  sha256 "c4a73b6974539dc6c5624bccf7c18d4613531a34af237f2c4a29e86c07741e1a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7d99e76b57c93e820efd0ed6d0547c863ddff30cabf387fe30e99a9d7fa5d644"
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
    assert_match "MD022/blanks-around-headings Headings should be surrounded by blank lines",
                 shell_output("#{bin}/markdownlint #{testpath}/test-bad.md  2>&1", 1)
    assert_empty shell_output("#{bin}/markdownlint #{testpath}/test-good.md")
  end
end
