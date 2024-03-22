require "language/node"

class MarkdownlintCli < Formula
  desc "CLI for Node.js style checker and lint tool for Markdown files"
  homepage "https://github.com/igorshubovych/markdownlint-cli"
  url "https://registry.npmjs.org/markdownlint-cli/-/markdownlint-cli-0.39.0.tgz"
  sha256 "3ac4533a0f5ea881fb0580818c0decb0b5c15627fa99aa005617866f6599e511"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7bc1310bfbeff34386c2b309988569bc6494b333edf9bf26d027fbecc1342c2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7bc1310bfbeff34386c2b309988569bc6494b333edf9bf26d027fbecc1342c2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bc1310bfbeff34386c2b309988569bc6494b333edf9bf26d027fbecc1342c2f"
    sha256 cellar: :any_skip_relocation, sonoma:         "0af1b50fb5bef4a0c47e1bd233e39262586885b48bc4c5a60592c5f42c2edf9f"
    sha256 cellar: :any_skip_relocation, ventura:        "0af1b50fb5bef4a0c47e1bd233e39262586885b48bc4c5a60592c5f42c2edf9f"
    sha256 cellar: :any_skip_relocation, monterey:       "0af1b50fb5bef4a0c47e1bd233e39262586885b48bc4c5a60592c5f42c2edf9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bc1310bfbeff34386c2b309988569bc6494b333edf9bf26d027fbecc1342c2f"
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
    assert_match "MD022/blanks-around-headings Headings should be surrounded by blank lines",
                 shell_output("#{bin}/markdownlint #{testpath}/test-bad.md  2>&1", 1)
    assert_empty shell_output("#{bin}/markdownlint #{testpath}/test-good.md")
  end
end
