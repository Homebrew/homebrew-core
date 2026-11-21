class MarkdownlintCli2 < Formula
  desc "Fast, flexible, config-based cli for linting Markdown/CommonMark files"
  homepage "https://github.com/DavidAnson/markdownlint-cli2"
  url "https://registry.npmjs.org/markdownlint-cli2/-/markdownlint-cli2-0.24.2.tgz"
  sha256 "4a18029af95ff232e08b8c0b4ba20ef521a7e45cc6216e26cbe4a14ddce3a24b"
  license "MIT"

  bottle do
    manifest_sha256 "03b60c92f09751510ea83b27850e9c504a59ac585109b4e93ebc2f553fe80a0b"
    sha256 cellar: :any_skip_relocation, all: "1df277047c0bbf7727836b67d4b34093e8e25a51f91acd943f1f53c90d4ed354"
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
