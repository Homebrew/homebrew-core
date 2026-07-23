class MarkdownlintCli2 < Formula
  desc "Fast, flexible, config-based cli for linting Markdown/CommonMark files"
  homepage "https://github.com/DavidAnson/markdownlint-cli2"
  url "https://registry.npmjs.org/markdownlint-cli2/-/markdownlint-cli2-0.23.1.tgz"
  sha256 "aa58192a70ef690f78148533c4c85fb706990bfb7a5ac2f6c1bfb8e935df047d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7cd486caeb7777d695a57f733a17b5e23df6356508238e7bbaac2259d6a4eaed"
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
