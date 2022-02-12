require "language/node"

class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-1.6.0.tgz"
  sha256 "c9e4300a18d1f5107ee10bbd3888116f53c8aee0a0df5f48964f963064101beb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "caf0cb6216de716ba431bd21a8fe7d9f53ced6d4281315bde190a7899f915aa0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "caf0cb6216de716ba431bd21a8fe7d9f53ced6d4281315bde190a7899f915aa0"
    sha256 cellar: :any_skip_relocation, monterey:       "a1191ac7f91ae38bd75b1ab67ccc39f9cd3e30d13483a037e6570032e9cee6f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1191ac7f91ae38bd75b1ab67ccc39f9cd3e30d13483a037e6570032e9cee6f8"
    sha256 cellar: :any_skip_relocation, catalina:       "a1191ac7f91ae38bd75b1ab67ccc39f9cd3e30d13483a037e6570032e9cee6f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f994907764a54c5ab10580a8cfe42ef344ce73dd74bb0e1732c33cd5500c442"
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
