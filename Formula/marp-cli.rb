require "language/node"

class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-3.0.0.tgz"
  sha256 "6c548934bd21d1512d87ce3766bf2e762730bcebf80bee9d53d3e7af7ea7be61"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a1fd9653dc38c4c99e3be64d393d514d892cb4b3b1e9bf9df22b5cd8475f0e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a1fd9653dc38c4c99e3be64d393d514d892cb4b3b1e9bf9df22b5cd8475f0e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a1fd9653dc38c4c99e3be64d393d514d892cb4b3b1e9bf9df22b5cd8475f0e0"
    sha256 cellar: :any_skip_relocation, ventura:        "49e558cc52dcb97ef607aa63dbfd4715928b8d2a3d9da8f4b925502ebcabf869"
    sha256 cellar: :any_skip_relocation, monterey:       "49e558cc52dcb97ef607aa63dbfd4715928b8d2a3d9da8f4b925502ebcabf869"
    sha256 cellar: :any_skip_relocation, big_sur:        "49e558cc52dcb97ef607aa63dbfd4715928b8d2a3d9da8f4b925502ebcabf869"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cc9a13777ab5d12d13cb1a43b2f6493283b1a86328e6a7df45943752d0140fc"
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
