require "language/node"

class MarkdownlintCli < Formula
  desc "CLI for Node.js style checker and lint tool for Markdown files"
  homepage "https://github.com/igorshubovych/markdownlint-cli"
  url "https://registry.npmjs.org/markdownlint-cli/-/markdownlint-cli-0.32.0.tgz"
  sha256 "cf088721f7ac57a51ccfb01419b295c93bad5f56b5ca1b814a7137f1de21c47a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "26519a6a4330fd29cd897e61f8af2070def21758b06517c136690a5404d07d5a"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test-bad.md").write <<~EOS
      # Header 1
      body
    EOS
    (testpath/"test-good.md").write <<~EOS
      # Header 1

      body
    EOS
    assert_match "MD022/blanks-around-headings/blanks-around-headers",
                 shell_output("#{bin}/markdownlint #{testpath}/test-bad.md  2>&1", 1)
    assert_empty shell_output("#{bin}/markdownlint #{testpath}/test-good.md")
  end
end
