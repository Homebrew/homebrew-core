require "language/node"

class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-3.2.0.tgz"
  sha256 "9bd51a60407db7c7fbeb063a0c3e7ff70fff46d6b386069aee6ecd855b82c577"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74412b4716a6026a797037398cd5ab55fb9069262048879443bba92af806932a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74412b4716a6026a797037398cd5ab55fb9069262048879443bba92af806932a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74412b4716a6026a797037398cd5ab55fb9069262048879443bba92af806932a"
    sha256 cellar: :any_skip_relocation, ventura:        "62432b95e15b9b470655fa6d99386dabf29e6e8c97fd14caf8b4772ac0924022"
    sha256 cellar: :any_skip_relocation, monterey:       "62432b95e15b9b470655fa6d99386dabf29e6e8c97fd14caf8b4772ac0924022"
    sha256 cellar: :any_skip_relocation, big_sur:        "62432b95e15b9b470655fa6d99386dabf29e6e8c97fd14caf8b4772ac0924022"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81fcc5492fb99e4fbec8e09d2545c9b3275de1780dc0756e8eb6f94e0bd2c68b"
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
