class MarkdownlintCli < Formula
  desc "CLI for Node.js style checker and lint tool for Markdown files"
  homepage "https://github.com/igorshubovych/markdownlint-cli"
  url "https://registry.npmjs.org/markdownlint-cli/-/markdownlint-cli-0.45.0.tgz"
  sha256 "8ce123a96b7a7f04f4dc684e9423f698fbf715c8f1fd17f2a2e1ce03f34d2a4e"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "84ca4dbbbaf8ea100674cec86f6f3d320053833bb46ee3b8ddc7ea399fc966bf"
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
