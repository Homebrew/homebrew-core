class MarkdownlintCli < Formula
  desc "CLI for Node.js style checker and lint tool for Markdown files"
  homepage "https://github.com/igorshubovych/markdownlint-cli"
  url "https://registry.npmjs.org/markdownlint-cli/-/markdownlint-cli-0.44.0.tgz"
  sha256 "df1ea79f06226d09e539f59e80b9c1f49baa01af3f97011fb5c621a3fd92bf6d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37d23e1edb5a0361a19123e2e6a2536b242bf37952c6c44d39256c6bd60cc7a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37d23e1edb5a0361a19123e2e6a2536b242bf37952c6c44d39256c6bd60cc7a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "37d23e1edb5a0361a19123e2e6a2536b242bf37952c6c44d39256c6bd60cc7a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "c85a970380cbbe474257782bf59f347f8c9ebd62af9258dc0df33f0806a1ca88"
    sha256 cellar: :any_skip_relocation, ventura:       "c85a970380cbbe474257782bf59f347f8c9ebd62af9258dc0df33f0806a1ca88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdb8a913761a1c7f03768d5d2eb86bb12b89161056d21e75d0d641d8d1873707"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37d23e1edb5a0361a19123e2e6a2536b242bf37952c6c44d39256c6bd60cc7a1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
