require "language/node"

class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-1.3.2.tgz"
  sha256 "8114f28a94b20ae3b722de361b4d151b18cf566d9adfebe382b539da2b195e39"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dac0e5525f58e1fb1d271456ec480d32328f10c35131756c83984569c1106fe0"
    sha256 cellar: :any_skip_relocation, big_sur:       "bdbe2397891c2df5abf0aae8d375cb9dcaeab86dc8ebe4053007f075941c2b4c"
    sha256 cellar: :any_skip_relocation, catalina:      "bdbe2397891c2df5abf0aae8d375cb9dcaeab86dc8ebe4053007f075941c2b4c"
    sha256 cellar: :any_skip_relocation, mojave:        "bdbe2397891c2df5abf0aae8d375cb9dcaeab86dc8ebe4053007f075941c2b4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "603512980adcf49d725eac9a430363ec6443c5a8757a1fdc0235e41110a77cbd"
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
