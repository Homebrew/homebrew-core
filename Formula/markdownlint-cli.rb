require "language/node"

class MarkdownlintCli < Formula
  desc "CLI for Node.js style checker and lint tool for Markdown files"
  homepage "https://github.com/igorshubovych/markdownlint-cli"
  url "https://registry.npmjs.org/markdownlint-cli/-/markdownlint-cli-0.33.0.tgz"
  sha256 "db3da4195fe53de3a696e728ffbb927c89b5997093aa1eb3ff711255ea86a42b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "075904ea0fceec4f953df170e952f7cbd48a67ea6661a621ecaf645ed3b38a11"
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
