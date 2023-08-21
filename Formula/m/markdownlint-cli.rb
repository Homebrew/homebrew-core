require "language/node"

class MarkdownlintCli < Formula
  desc "CLI for Node.js style checker and lint tool for Markdown files"
  homepage "https://github.com/igorshubovych/markdownlint-cli"
  url "https://registry.npmjs.org/markdownlint-cli/-/markdownlint-cli-0.35.0.tgz"
  sha256 "ab5c263cf3f82b6eec0449ad5f5bd6701940502bdbc99f78d42f0f6e726be2dc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f1f6f9fe527180d38e1125fd74fa92a84e6c9f560e99328b611dd838f7ccc63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f1f6f9fe527180d38e1125fd74fa92a84e6c9f560e99328b611dd838f7ccc63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f1f6f9fe527180d38e1125fd74fa92a84e6c9f560e99328b611dd838f7ccc63"
    sha256 cellar: :any_skip_relocation, ventura:        "78205ffb0175e0a541d348b30553ff8bc6d423e3161fffb40b39605ce3b55e76"
    sha256 cellar: :any_skip_relocation, monterey:       "78205ffb0175e0a541d348b30553ff8bc6d423e3161fffb40b39605ce3b55e76"
    sha256 cellar: :any_skip_relocation, big_sur:        "78205ffb0175e0a541d348b30553ff8bc6d423e3161fffb40b39605ce3b55e76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f1f6f9fe527180d38e1125fd74fa92a84e6c9f560e99328b611dd838f7ccc63"
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
