require "language/node"

class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-1.7.1.tgz"
  sha256 "f0c8b299df2396007ece9253d215d9a39600ed0dc24135febfcfe5aaf8befe36"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69963c9971b88e24f3dbb505662f1e13a06b25d9199bd8a1252e01d96dccd93d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69963c9971b88e24f3dbb505662f1e13a06b25d9199bd8a1252e01d96dccd93d"
    sha256 cellar: :any_skip_relocation, monterey:       "63577dd75be509a244900e91d7c50a556c2042a992fd7a545b849e27dc330b12"
    sha256 cellar: :any_skip_relocation, big_sur:        "63577dd75be509a244900e91d7c50a556c2042a992fd7a545b849e27dc330b12"
    sha256 cellar: :any_skip_relocation, catalina:       "63577dd75be509a244900e91d7c50a556c2042a992fd7a545b849e27dc330b12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd3e32eba27f7f5d709b5b445303767689d1f4019d932d0c4a499eb085feb85d"
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
