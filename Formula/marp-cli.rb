require "language/node"

class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-1.7.2.tgz"
  sha256 "e67b4ae390c38a5c1dcdcdd4d0b7db62c975a9db7ab3ec9871e549231a32d928"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b34780112ac10be44bcec54ec6cad40812ef5b661ce9a69c39394f5a2a8e7c81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b34780112ac10be44bcec54ec6cad40812ef5b661ce9a69c39394f5a2a8e7c81"
    sha256 cellar: :any_skip_relocation, monterey:       "066c82f62155ae5983927928f42b2062a2a35d58bb554188850d9f9491100968"
    sha256 cellar: :any_skip_relocation, big_sur:        "066c82f62155ae5983927928f42b2062a2a35d58bb554188850d9f9491100968"
    sha256 cellar: :any_skip_relocation, catalina:       "066c82f62155ae5983927928f42b2062a2a35d58bb554188850d9f9491100968"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbd01b74d35398f6dd0dfd277bd4eadd64323e479ebd60826c1e1d13c1727112"
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
