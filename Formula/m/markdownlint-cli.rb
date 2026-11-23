class MarkdownlintCli < Formula
  desc "CLI for Node.js style checker and lint tool for Markdown files"
  homepage "https://github.com/igorshubovych/markdownlint-cli"
  url "https://registry.npmjs.org/markdownlint-cli/-/markdownlint-cli-0.50.1.tgz"
  sha256 "abb8b417ec71583123911a886975aba8c127ce8c6cbec04a6b404cec486c2ebe"
  license "MIT"

  bottle do
    manifest_sha256 "18eb4f5ac9cfd66240f56bbb95ecfe5b22bcdb46bacc6bb44dd881f8555e580a"
    sha256 cellar: :any_skip_relocation, all: "847fe36c1dc6d9f911e683cdafbb05d6b5bbf85b24f4576671cba67c691d7560"
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
