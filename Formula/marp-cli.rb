require "language/node"

class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-1.5.0.tgz"
  sha256 "4e8d0644fee834cd9531e1ea5285982d9ed12c79e01483b440eb1a1faca52d1d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5305169e7f757ae582a84ec000be5bf72bc0b6a007359d030d295ce0370f3d14"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5305169e7f757ae582a84ec000be5bf72bc0b6a007359d030d295ce0370f3d14"
    sha256 cellar: :any_skip_relocation, monterey:       "c0e365b67f65842f4efc420778a189899e22194d7c815fa620218f3723948502"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0e365b67f65842f4efc420778a189899e22194d7c815fa620218f3723948502"
    sha256 cellar: :any_skip_relocation, catalina:       "c0e365b67f65842f4efc420778a189899e22194d7c815fa620218f3723948502"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b6ca4654cc85b9a7546e63b9191500fe899b1868407d428044210752f2e938d"
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
