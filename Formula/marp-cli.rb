require "language/node"

class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-2.2.0.tgz"
  sha256 "08a182f9630cb19960f44734f2ea3fb67ac79cf52b81c5a04a849ac06556d174"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3e749b3344ed5bbeba63d79c99b5706615c7f946e967843892368fe793d1300"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83f2f4333b43ab7bb31d809d4493022a45498e0ed3934edc2c69597fa2206c19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83f2f4333b43ab7bb31d809d4493022a45498e0ed3934edc2c69597fa2206c19"
    sha256 cellar: :any_skip_relocation, ventura:        "2c7a3e612d60cc20890b17c55de2f865cb5ff71187877a729b5aa4760164b904"
    sha256 cellar: :any_skip_relocation, monterey:       "9da350a4b17e8978544dabdaf9f3c130773b1e265e9e3fc8b36a13f81f210b08"
    sha256 cellar: :any_skip_relocation, big_sur:        "9da350a4b17e8978544dabdaf9f3c130773b1e265e9e3fc8b36a13f81f210b08"
    sha256 cellar: :any_skip_relocation, catalina:       "9da350a4b17e8978544dabdaf9f3c130773b1e265e9e3fc8b36a13f81f210b08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "031903fd1734fccb983b9f6f48b9fa65fcb640d1c4f318630276c6b93d8234df"
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
