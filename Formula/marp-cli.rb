require "language/node"

class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-2.5.0.tgz"
  sha256 "c0ded8770e2efa66c8768ffb9d7373890da5be9c80bb7a092dfeab5aa2d7967f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ba50381ecc48b908d316c5b231cbb7943d8ae259ca95baaec120faf1e8fb3dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ba50381ecc48b908d316c5b231cbb7943d8ae259ca95baaec120faf1e8fb3dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ba50381ecc48b908d316c5b231cbb7943d8ae259ca95baaec120faf1e8fb3dc"
    sha256 cellar: :any_skip_relocation, ventura:        "a9a8a24428c2b444c8a685a482966c8b415d55444617b9d1c0fc87cdd737d078"
    sha256 cellar: :any_skip_relocation, monterey:       "a9a8a24428c2b444c8a685a482966c8b415d55444617b9d1c0fc87cdd737d078"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9a8a24428c2b444c8a685a482966c8b415d55444617b9d1c0fc87cdd737d078"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dbcfe79b02e0b87cd76d17262adce819dbd78d18f9b483edac1a73e438f80d0"
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
