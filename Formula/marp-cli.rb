require "language/node"

class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-2.0.4.tgz"
  sha256 "be653c39c57ee00d219742e0634301af2f1fb17254b8cec449903646bcf5429d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fde9f13f663b60e41bafb605c4d16c6952b9dabee131e3ab712a86e2b850270"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3fde9f13f663b60e41bafb605c4d16c6952b9dabee131e3ab712a86e2b850270"
    sha256 cellar: :any_skip_relocation, monterey:       "da8378ed9b22ae86b5af9fed120125b8a83ca3c5fbed7a3e32c5d69e54ea630c"
    sha256 cellar: :any_skip_relocation, big_sur:        "da8378ed9b22ae86b5af9fed120125b8a83ca3c5fbed7a3e32c5d69e54ea630c"
    sha256 cellar: :any_skip_relocation, catalina:       "da8378ed9b22ae86b5af9fed120125b8a83ca3c5fbed7a3e32c5d69e54ea630c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14597891610727131890ab6ac8726fdbe46b366cffeca938871c4251fe6f9420"
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
