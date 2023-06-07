require "language/node"

class MarkdownlintCli < Formula
  desc "CLI for Node.js style checker and lint tool for Markdown files"
  homepage "https://github.com/igorshubovych/markdownlint-cli"
  url "https://registry.npmjs.org/markdownlint-cli/-/markdownlint-cli-0.34.0.tgz"
  sha256 "f41e4a7337ffc9a00b902dccdab240f5141859b86bb0f5bfacdc4556e812e6ee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6fe846f96176e8b0d225d35567239b92846daa569132583d2ae98e4af5699a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6fe846f96176e8b0d225d35567239b92846daa569132583d2ae98e4af5699a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6fe846f96176e8b0d225d35567239b92846daa569132583d2ae98e4af5699a0"
    sha256 cellar: :any_skip_relocation, ventura:        "1269f50059c47f83b7ad61197fd0cc970f5612a492467a63daf6e32c131949bb"
    sha256 cellar: :any_skip_relocation, monterey:       "1269f50059c47f83b7ad61197fd0cc970f5612a492467a63daf6e32c131949bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "1269f50059c47f83b7ad61197fd0cc970f5612a492467a63daf6e32c131949bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6fe846f96176e8b0d225d35567239b92846daa569132583d2ae98e4af5699a0"
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
