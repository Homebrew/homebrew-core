require "language/node"

class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-3.3.0.tgz"
  sha256 "ec29d428f245a63f22418ab55d1e805083bcb7ff4cb62069d401d15664703c7c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7197ee90d0b8b55f3f60b1136aac1b63eee42cacb260774a5814cb8508eaaf0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7197ee90d0b8b55f3f60b1136aac1b63eee42cacb260774a5814cb8508eaaf0b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7197ee90d0b8b55f3f60b1136aac1b63eee42cacb260774a5814cb8508eaaf0b"
    sha256 cellar: :any_skip_relocation, ventura:        "b3c32b1aa03f8d7310fe27a3149b99c0e97c63c3e3de97039c6f5f93f88bc7fa"
    sha256 cellar: :any_skip_relocation, monterey:       "b3c32b1aa03f8d7310fe27a3149b99c0e97c63c3e3de97039c6f5f93f88bc7fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3c32b1aa03f8d7310fe27a3149b99c0e97c63c3e3de97039c6f5f93f88bc7fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5a4c40a676f47f2fd3f1aa834dedb4f5d528521ded67bca77a7f6e11877b846"
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
