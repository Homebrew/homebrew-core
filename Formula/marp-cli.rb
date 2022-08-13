require "language/node"

class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-2.1.2.tgz"
  sha256 "cd8acb76d3d7a5f1cf128c5504a0861dbe86fbb22f83b664c290c1b00e1c9c16"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75390e4d91860c1ff205189ade24cfcfcc751dfe3f21142eb340919b7ccc7287"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75390e4d91860c1ff205189ade24cfcfcc751dfe3f21142eb340919b7ccc7287"
    sha256 cellar: :any_skip_relocation, monterey:       "714c7e0fcde788f35cc8f0137567d7e6a70255767f83789b885d2b2413fad323"
    sha256 cellar: :any_skip_relocation, big_sur:        "714c7e0fcde788f35cc8f0137567d7e6a70255767f83789b885d2b2413fad323"
    sha256 cellar: :any_skip_relocation, catalina:       "714c7e0fcde788f35cc8f0137567d7e6a70255767f83789b885d2b2413fad323"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be2cad79da8eba24023e4af652890b987dd92be119520879cdda037a0cb137cf"
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
