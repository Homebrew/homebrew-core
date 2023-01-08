require "language/node"

class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-2.3.0.tgz"
  sha256 "aa297d401756b9c2992935d18e53e1c2c3ad9529588d74a0c950e277b3499428"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d3709b152ec1ae5a4c93ce8a1d0ad8b5b2345782a293b7c81bff408d19df8f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d3709b152ec1ae5a4c93ce8a1d0ad8b5b2345782a293b7c81bff408d19df8f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d3709b152ec1ae5a4c93ce8a1d0ad8b5b2345782a293b7c81bff408d19df8f8"
    sha256 cellar: :any_skip_relocation, ventura:        "57e645d5295baa70bd7b8fab37a415ba0a09936dcb63d01cec72b7abce136ca1"
    sha256 cellar: :any_skip_relocation, monterey:       "57e645d5295baa70bd7b8fab37a415ba0a09936dcb63d01cec72b7abce136ca1"
    sha256 cellar: :any_skip_relocation, big_sur:        "57e645d5295baa70bd7b8fab37a415ba0a09936dcb63d01cec72b7abce136ca1"
    sha256 cellar: :any_skip_relocation, catalina:       "57e645d5295baa70bd7b8fab37a415ba0a09936dcb63d01cec72b7abce136ca1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3afd350be8f362579de77f5b2e0a7113375f94f691141be8dd983b88e6e504de"
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
