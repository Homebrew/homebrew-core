require "language/node"

class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-2.4.0.tgz"
  sha256 "ee03bd9ee85d5c5eb7aa8dd361818163daafb118f244d648b69edc5d4e242963"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54b99863b43bd661040432ba033c930bdeb523a6b3a1a47f8b04b78f3b94b817"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54b99863b43bd661040432ba033c930bdeb523a6b3a1a47f8b04b78f3b94b817"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54b99863b43bd661040432ba033c930bdeb523a6b3a1a47f8b04b78f3b94b817"
    sha256 cellar: :any_skip_relocation, ventura:        "eeb05c478f02916031c91af4a18d7f48f278426b0acf965af95ca3517fdb73f3"
    sha256 cellar: :any_skip_relocation, monterey:       "eeb05c478f02916031c91af4a18d7f48f278426b0acf965af95ca3517fdb73f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "eeb05c478f02916031c91af4a18d7f48f278426b0acf965af95ca3517fdb73f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0455db0de1b53e40ab06519622ea1ade7b10531523d8d8ebdac873062230ea1d"
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
    assert_match "<h1>Hello, Homebrew!</h1>", content
    assert_match "background-color:blue", content
    assert_match "👍", content
  end
end
