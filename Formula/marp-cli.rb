require "language/node"

class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-1.7.2.tgz"
  sha256 "e67b4ae390c38a5c1dcdcdd4d0b7db62c975a9db7ab3ec9871e549231a32d928"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9891f6bdccd810f899b2acf46e9ea145a70ab15e629842c6a4713134f56789e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9891f6bdccd810f899b2acf46e9ea145a70ab15e629842c6a4713134f56789e7"
    sha256 cellar: :any_skip_relocation, monterey:       "30504eb972765913d2e2ca08b4e35980ca3a9fb373cb6c0fca5a875d08299cc4"
    sha256 cellar: :any_skip_relocation, big_sur:        "30504eb972765913d2e2ca08b4e35980ca3a9fb373cb6c0fca5a875d08299cc4"
    sha256 cellar: :any_skip_relocation, catalina:       "30504eb972765913d2e2ca08b4e35980ca3a9fb373cb6c0fca5a875d08299cc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "775b30d9938fdf229312de757eb67f6041846db54b2069726bba130c7be7a2f3"
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
