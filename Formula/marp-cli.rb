require "language/node"

class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-3.0.2.tgz"
  sha256 "bbec8cede613d1a6f19b2602d35ce49062c430e2b82590a1e88065c57befe206"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbbf144c865bffabb6f3098587b0a9a165e30623c210c731cad4133aaa833908"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbbf144c865bffabb6f3098587b0a9a165e30623c210c731cad4133aaa833908"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cbbf144c865bffabb6f3098587b0a9a165e30623c210c731cad4133aaa833908"
    sha256 cellar: :any_skip_relocation, ventura:        "024ccfe485fe2ee6d211d47146f70de8b173d34c5bca42fbe4da02aeacd98b0d"
    sha256 cellar: :any_skip_relocation, monterey:       "024ccfe485fe2ee6d211d47146f70de8b173d34c5bca42fbe4da02aeacd98b0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "024ccfe485fe2ee6d211d47146f70de8b173d34c5bca42fbe4da02aeacd98b0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f1b836b373d23d2bda832a869a04565d3d8d9298468d9046b6303b76b8344c5"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"deck.md").write <<~EOS
      ---
      theme: uncover
      ---

      # Hello, Homebrew!

      ---

      <!-- backgroundColor: blue -->

      # <!--fit--> :+1:
    EOS

    system bin/"marp", testpath/"deck.md", "-o", testpath/"deck.html"
    assert_predicate testpath/"deck.html", :exist?
    content = (testpath/"deck.html").read
    assert_match "theme:uncover", content
    assert_match "<h1 id=\"hello-homebrew\">Hello, Homebrew!</h1>", content
    assert_match "background-color:blue", content
    assert_match "👍", content
  end
end
