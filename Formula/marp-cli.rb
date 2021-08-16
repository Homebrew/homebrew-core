require "language/node"

class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-1.3.1.tgz"
  sha256 "52f74798a61a20a20f592f13fdb555d4335e5215de4b3fc7834baebbd2bb77a7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "09b3ff38e986a3ed85f822f104f46233a459be462e9d57d415d530c7bbf793d3"
    sha256 cellar: :any_skip_relocation, big_sur:       "75248eb7558bea82bc196679f42d5634fea39d8e9f3c43749767ecf02c0a14b6"
    sha256 cellar: :any_skip_relocation, catalina:      "75248eb7558bea82bc196679f42d5634fea39d8e9f3c43749767ecf02c0a14b6"
    sha256 cellar: :any_skip_relocation, mojave:        "75248eb7558bea82bc196679f42d5634fea39d8e9f3c43749767ecf02c0a14b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6693f754c48a19c7c6a9184c975f922a5eead83351cfd8e308aa4a8c4f620b68"
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
