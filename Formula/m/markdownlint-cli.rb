class MarkdownlintCli < Formula
  desc "CLI for Node.js style checker and lint tool for Markdown files"
  homepage "https://github.com/igorshubovych/markdownlint-cli"
  url "https://registry.npmjs.org/markdownlint-cli/-/markdownlint-cli-0.42.0.tgz"
  sha256 "1e7dc49376b223556f569ffc85b925bd6b7134a911be78770e1a8ac7d0f1e0f2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3e5181a75b8fb131ac22c9c63635573d403a3d720ef0c72bd58cecfb3c2fe3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3e5181a75b8fb131ac22c9c63635573d403a3d720ef0c72bd58cecfb3c2fe3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a3e5181a75b8fb131ac22c9c63635573d403a3d720ef0c72bd58cecfb3c2fe3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "758ba29dba62e69b33801d519cbf6186a84320adf3e8e08bda862c9b057c22e5"
    sha256 cellar: :any_skip_relocation, ventura:       "758ba29dba62e69b33801d519cbf6186a84320adf3e8e08bda862c9b057c22e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3e5181a75b8fb131ac22c9c63635573d403a3d720ef0c72bd58cecfb3c2fe3e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
    assert_match "MD022/blanks-around-headings Headings should be surrounded by blank lines",
                 shell_output("#{bin}/markdownlint #{testpath}/test-bad.md  2>&1", 1)
    assert_empty shell_output("#{bin}/markdownlint #{testpath}/test-good.md")
  end
end
