require "language/node"

class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-1.4.0.tgz"
  sha256 "639c19210e53c59499fbec249fe6a4d7c1255eb98fdb6954fe891a0e7e2bb77e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a3b04e3effbe74bb7a7bb98d530627f146e05805e576398c56b44821730dcbfb"
    sha256 cellar: :any_skip_relocation, big_sur:       "1db9991fda4da950ff397110e7026e6b5a9b93699c3c3d71d3f5fb9e47353110"
    sha256 cellar: :any_skip_relocation, catalina:      "1db9991fda4da950ff397110e7026e6b5a9b93699c3c3d71d3f5fb9e47353110"
    sha256 cellar: :any_skip_relocation, mojave:        "1db9991fda4da950ff397110e7026e6b5a9b93699c3c3d71d3f5fb9e47353110"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dacf7aeda92c258c9b6bce77f6767a8ce06a2ca95a5ae0aace5e2fd79bd6e4eb"
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
