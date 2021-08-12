require "language/node"

class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-1.3.0.tgz"
  sha256 "3135cf55081f2b31b5dfc650fa9fd8f4a70772e6daffa286eeddf7e5cc7f609f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9850659ea2c01965c628ba2838f794fb8569a5f7adcac8de27c3f5cbdc5219ac"
    sha256 cellar: :any_skip_relocation, big_sur:       "e5a7f20a94b29947f50a17cb5139bf3eb4cf4f9e38a84ff2a58084bb71fefc11"
    sha256 cellar: :any_skip_relocation, catalina:      "e5a7f20a94b29947f50a17cb5139bf3eb4cf4f9e38a84ff2a58084bb71fefc11"
    sha256 cellar: :any_skip_relocation, mojave:        "e5a7f20a94b29947f50a17cb5139bf3eb4cf4f9e38a84ff2a58084bb71fefc11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "432de5792e2b3cfc864c28109593bbdc60cf6c65f86134ee90e6c91ab488f56d"
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
