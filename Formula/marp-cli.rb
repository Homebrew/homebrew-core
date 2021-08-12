require "language/node"

class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-1.3.0.tgz"
  sha256 "3135cf55081f2b31b5dfc650fa9fd8f4a70772e6daffa286eeddf7e5cc7f609f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e26d6dd770e30bc23efb8eb80f14d487c0eb8895bbda16cc935e56866a92e1bb"
    sha256 cellar: :any_skip_relocation, big_sur:       "923196c727bc3b5b6a0c6eb695a9956460c88b66df5c2084c68155b7a8329b4e"
    sha256 cellar: :any_skip_relocation, catalina:      "923196c727bc3b5b6a0c6eb695a9956460c88b66df5c2084c68155b7a8329b4e"
    sha256 cellar: :any_skip_relocation, mojave:        "923196c727bc3b5b6a0c6eb695a9956460c88b66df5c2084c68155b7a8329b4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "350e742a8306fa576ed9be835d166dd1a12a5ee471899a68e6a42294e78ce2e7"
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
