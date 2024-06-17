require "language/node"

class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-3.4.0.tgz"
  sha256 "9e21cbb1e24507bc9f6d4c9449ff6d9ce374fef42cd1fafc2c15b42dd702bdb3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5832f718afc05b56019621c61165e199f659d9ea90c36003702e60095816e4d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5832f718afc05b56019621c61165e199f659d9ea90c36003702e60095816e4d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5832f718afc05b56019621c61165e199f659d9ea90c36003702e60095816e4d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "5bc827178f06c452d345a198244214892d638578f723c3ce29a30b00d84ac104"
    sha256 cellar: :any_skip_relocation, ventura:        "5bc827178f06c452d345a198244214892d638578f723c3ce29a30b00d84ac104"
    sha256 cellar: :any_skip_relocation, monterey:       "5bc827178f06c452d345a198244214892d638578f723c3ce29a30b00d84ac104"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e252e61548d221f12fc21c00c0fc29cc2bde145e292fe1460de7ddd85e78de5"
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
