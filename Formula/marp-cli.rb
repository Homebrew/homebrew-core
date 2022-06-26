require "language/node"

class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-2.0.4.tgz"
  sha256 "be653c39c57ee00d219742e0634301af2f1fb17254b8cec449903646bcf5429d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9abfc30732daa6c854115ced0ca662956a706a70e8682643f3aaeacf84d49c6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9abfc30732daa6c854115ced0ca662956a706a70e8682643f3aaeacf84d49c6d"
    sha256 cellar: :any_skip_relocation, monterey:       "d0a8c71c0e36ee8e278bd3bbe839d6fd16c078a2f4edda6c12c89a5d7a91fc85"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0a8c71c0e36ee8e278bd3bbe839d6fd16c078a2f4edda6c12c89a5d7a91fc85"
    sha256 cellar: :any_skip_relocation, catalina:       "d0a8c71c0e36ee8e278bd3bbe839d6fd16c078a2f4edda6c12c89a5d7a91fc85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c2e3e7e382d9897f6c8f5c801ad51a6e2a3d7a1d2aa9426cf04c66fe855ffaf"
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
