require "language/node"

class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-2.1.1.tgz"
  sha256 "7dfd5c1da07ea26f5a45b935f8fecff7c6eed1573187bb1d59913b37b641037a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58670fd1cb5c5170c859d1f5268339ae2c8f4fc8ebe5a39000b4b8a62bfc4824"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58670fd1cb5c5170c859d1f5268339ae2c8f4fc8ebe5a39000b4b8a62bfc4824"
    sha256 cellar: :any_skip_relocation, monterey:       "ea5e1d921b1d788539757986d19caf83ec0f1c9552264456ad8876076ddc14b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea5e1d921b1d788539757986d19caf83ec0f1c9552264456ad8876076ddc14b8"
    sha256 cellar: :any_skip_relocation, catalina:       "ea5e1d921b1d788539757986d19caf83ec0f1c9552264456ad8876076ddc14b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11d3b38662d3a3f315741d0ae82f086e663d7849ff1b0b73ac08d210030da1e7"
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
