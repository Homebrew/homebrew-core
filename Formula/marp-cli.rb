require "language/node"

class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-1.1.1.tgz"
  sha256 "62711d9298f96a9634020d31a05561ad076e59e06749b0be643a20ccb8533770"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c7497d7d226b8ace2ba4f24a231c946d13683acdf9ec40a91fd37c66e6e80aee"
    sha256 cellar: :any_skip_relocation, big_sur:       "9fbc8ace15dc205f82033d8636df4c56e96fea5c544557ec114753fce91cadc4"
    sha256 cellar: :any_skip_relocation, catalina:      "9fbc8ace15dc205f82033d8636df4c56e96fea5c544557ec114753fce91cadc4"
    sha256 cellar: :any_skip_relocation, mojave:        "9fbc8ace15dc205f82033d8636df4c56e96fea5c544557ec114753fce91cadc4"
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

    system "marp", testpath/"deck.md", "-o", testpath/"deck.html"
    assert_predicate testpath/"deck.html", :exist?
    content = (testpath/"deck.html").read
    assert_match "theme:uncover", content
    assert_match "<h1>Hello, Homebrew!</h1>", content
    assert_match "background-color:blue", content
    assert_match "👍", content
  end
end
