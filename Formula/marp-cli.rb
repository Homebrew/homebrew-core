require "language/node"

class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-1.6.0.tgz"
  sha256 "c9e4300a18d1f5107ee10bbd3888116f53c8aee0a0df5f48964f963064101beb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d823bd55cf3dfb38de55c1d32cd009a2c2fff3bb4efbb109b37b7530e03a4b70"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d823bd55cf3dfb38de55c1d32cd009a2c2fff3bb4efbb109b37b7530e03a4b70"
    sha256 cellar: :any_skip_relocation, monterey:       "e741909aacdc96bfa01dae2d7d7adcf56b95838e82b6d33c36bc80bbe9711968"
    sha256 cellar: :any_skip_relocation, big_sur:        "e741909aacdc96bfa01dae2d7d7adcf56b95838e82b6d33c36bc80bbe9711968"
    sha256 cellar: :any_skip_relocation, catalina:       "e741909aacdc96bfa01dae2d7d7adcf56b95838e82b6d33c36bc80bbe9711968"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef25c3e41934ada4a1b99b885ac0925f81425009e95edf7b073f39e32f2d112e"
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
