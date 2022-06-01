require "language/node"

class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-2.0.1.tgz"
  sha256 "c8972ae7f2dcc53f5545e2fb34a4e0d5e20a8ce3a1d4ad2c51590a7c22beb4a7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4ecf53181280ee929ff54aadbd8a835e5494a5f897766a5e8d4ecb35c1d714d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4ecf53181280ee929ff54aadbd8a835e5494a5f897766a5e8d4ecb35c1d714d"
    sha256 cellar: :any_skip_relocation, monterey:       "692b0a95e68ef44405e77df9c884dfc149bbb3b7ff14fc0f17d82d15eaf946cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "692b0a95e68ef44405e77df9c884dfc149bbb3b7ff14fc0f17d82d15eaf946cd"
    sha256 cellar: :any_skip_relocation, catalina:       "692b0a95e68ef44405e77df9c884dfc149bbb3b7ff14fc0f17d82d15eaf946cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54af39c88f2e19da643b0e58b322c55d65928001092ee689b79f24d886867dc7"
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
