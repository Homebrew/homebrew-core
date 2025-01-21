class MarkdownlintCli < Formula
  desc "CLI for Node.js style checker and lint tool for Markdown files"
  homepage "https://github.com/igorshubovych/markdownlint-cli"
  url "https://registry.npmjs.org/markdownlint-cli/-/markdownlint-cli-0.43.0.tgz"
  sha256 "75f368cda3622f32df0971f834aee6bccaa64b7d1baffce021bb962328be316b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b821b6668e1fb447f4be2a67ea43544913b7e17bcd2fd8d7374cd7422239704"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b821b6668e1fb447f4be2a67ea43544913b7e17bcd2fd8d7374cd7422239704"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b821b6668e1fb447f4be2a67ea43544913b7e17bcd2fd8d7374cd7422239704"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c474cd8d82383adbdb5f98012721beaf18a515754dc9fd4e7affe421a5af6d5"
    sha256 cellar: :any_skip_relocation, ventura:       "3c474cd8d82383adbdb5f98012721beaf18a515754dc9fd4e7affe421a5af6d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b821b6668e1fb447f4be2a67ea43544913b7e17bcd2fd8d7374cd7422239704"
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
