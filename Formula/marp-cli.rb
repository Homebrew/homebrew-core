require "language/node"

class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-2.2.0.tgz"
  sha256 "08a182f9630cb19960f44734f2ea3fb67ac79cf52b81c5a04a849ac06556d174"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "343cbcfb6ca07582e2eb66de206e3b5ca1ef7e25d2dbdf587b08b7df4409bd02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "343cbcfb6ca07582e2eb66de206e3b5ca1ef7e25d2dbdf587b08b7df4409bd02"
    sha256 cellar: :any_skip_relocation, monterey:       "1b7c044fdb57f4ea1bc8aba3fbe8cf0af8893dd2b21ab44a5d134d7e442758db"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b7c044fdb57f4ea1bc8aba3fbe8cf0af8893dd2b21ab44a5d134d7e442758db"
    sha256 cellar: :any_skip_relocation, catalina:       "1b7c044fdb57f4ea1bc8aba3fbe8cf0af8893dd2b21ab44a5d134d7e442758db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8e3d5974cfbb16d4155c56deec784eaed0368a21c33aab928c12b32ebb4bba3"
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
