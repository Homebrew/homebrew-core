require "language/node"

class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-3.2.1.tgz"
  sha256 "b5101d610883e4eab1450dc5dadfc07e4e5bfdcf9f742c9fcc515bf4c7431975"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8e4969f4f8a16f8e1758d55576d36fb3e10222868d5372805c55d2aa5e3c325"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8e4969f4f8a16f8e1758d55576d36fb3e10222868d5372805c55d2aa5e3c325"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8e4969f4f8a16f8e1758d55576d36fb3e10222868d5372805c55d2aa5e3c325"
    sha256 cellar: :any_skip_relocation, ventura:        "0e48e9cf181964bffc903d7011b5deddb0cc16687dfc9e94f1711a375e44f721"
    sha256 cellar: :any_skip_relocation, monterey:       "0e48e9cf181964bffc903d7011b5deddb0cc16687dfc9e94f1711a375e44f721"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e48e9cf181964bffc903d7011b5deddb0cc16687dfc9e94f1711a375e44f721"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8e9f3577519ab821935442eaee657c82e9c7eea5db4ab85b5e7cc7662845145"
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
