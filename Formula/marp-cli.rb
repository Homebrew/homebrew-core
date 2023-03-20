require "language/node"

class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-2.4.0.tgz"
  sha256 "ee03bd9ee85d5c5eb7aa8dd361818163daafb118f244d648b69edc5d4e242963"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02a8a1f9c0d1d29742ac5a3efc85cffc1276367e0f28ae4053ae0157c976fe7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02a8a1f9c0d1d29742ac5a3efc85cffc1276367e0f28ae4053ae0157c976fe7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02a8a1f9c0d1d29742ac5a3efc85cffc1276367e0f28ae4053ae0157c976fe7c"
    sha256 cellar: :any_skip_relocation, ventura:        "72fbe13449386b62e6ae2d5160c4d130abec7d5c35dc7c6f1301fb7a72603204"
    sha256 cellar: :any_skip_relocation, monterey:       "72fbe13449386b62e6ae2d5160c4d130abec7d5c35dc7c6f1301fb7a72603204"
    sha256 cellar: :any_skip_relocation, big_sur:        "72fbe13449386b62e6ae2d5160c4d130abec7d5c35dc7c6f1301fb7a72603204"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06aa44cf13b6eae50f398e47808bce12b8c0bb0be87bac1dc632b2380df20831"
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
