class MarkdownlintCli2 < Formula
  desc "Fast, flexible, config-based cli for linting Markdown/CommonMark files"
  homepage "https://github.com/DavidAnson/markdownlint-cli2"
  url "https://registry.npmjs.org/markdownlint-cli2/-/markdownlint-cli2-0.23.0.tgz"
  sha256 "40097fb79f209d96a1ebf5043c0295d9d75e3909ec0eb817af098415d4ff0b8c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "28592cc91bedd8e6ef9509778d0af9b23c2349e8326417f2be4e8363dad761e9"
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
    assert_match "Summary: 1 error(s)",
      shell_output("#{bin}/markdownlint-cli2 :#{testpath}/test-bad.md 2>&1", 1)
    assert_match "Summary: 0 error(s)",
      shell_output("#{bin}/markdownlint-cli2 :#{testpath}/test-good.md")
  end
end
