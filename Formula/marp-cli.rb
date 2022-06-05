require "language/node"

class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-2.0.2.tgz"
  sha256 "20c1bfb48f5d7067781b70af4c0358450bd1ec7758bf5c519ae9b2a1b3a61a30"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e58c01ec338007a4d1cae97ae6435a7aaac5c1d5e54619c49ee4809339256c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e58c01ec338007a4d1cae97ae6435a7aaac5c1d5e54619c49ee4809339256c3"
    sha256 cellar: :any_skip_relocation, monterey:       "736f11e9d400654cb9d2fa8c0c8bce3d8725f8b0b8c6eea7085fc0aee16038b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "736f11e9d400654cb9d2fa8c0c8bce3d8725f8b0b8c6eea7085fc0aee16038b2"
    sha256 cellar: :any_skip_relocation, catalina:       "736f11e9d400654cb9d2fa8c0c8bce3d8725f8b0b8c6eea7085fc0aee16038b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8070b4c48193248cb19b377797792a9ed9fd062f89b4ebf27eddd74ab79b72f"
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
