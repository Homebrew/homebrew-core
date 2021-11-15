require "language/node"

class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-1.4.2.tgz"
  sha256 "44ba2ec584cdb5091ecb76efda633f51389a66f91fcc83823d834256d2d458e6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90957118931efffab0929a71f771d6769b87167db966815dc72be1ca7ffa354a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90957118931efffab0929a71f771d6769b87167db966815dc72be1ca7ffa354a"
    sha256 cellar: :any_skip_relocation, monterey:       "e62f64281546d7dca7170f7550c7de87ccece8b2ae675c1bbf6a16dedade800c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e62f64281546d7dca7170f7550c7de87ccece8b2ae675c1bbf6a16dedade800c"
    sha256 cellar: :any_skip_relocation, catalina:       "e62f64281546d7dca7170f7550c7de87ccece8b2ae675c1bbf6a16dedade800c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f8385d143f38ea1894be22449be34fb593b29a11d67aba47561584e12dc9da4"
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
