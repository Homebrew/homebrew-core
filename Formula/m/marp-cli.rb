class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-3.4.0.tgz"
  sha256 "9e21cbb1e24507bc9f6d4c9449ff6d9ce374fef42cd1fafc2c15b42dd702bdb3"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "053d8f7070f38272319fc1511e1c54658202dcea894554672b56cb594f5a7fe1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "053d8f7070f38272319fc1511e1c54658202dcea894554672b56cb594f5a7fe1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "053d8f7070f38272319fc1511e1c54658202dcea894554672b56cb594f5a7fe1"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf72d0b39d9c95a68ef4295f6b34a20371b9c87a28034006dac62ca91ba4a2a5"
    sha256 cellar: :any_skip_relocation, ventura:        "cf72d0b39d9c95a68ef4295f6b34a20371b9c87a28034006dac62ca91ba4a2a5"
    sha256 cellar: :any_skip_relocation, monterey:       "cf72d0b39d9c95a68ef4295f6b34a20371b9c87a28034006dac62ca91ba4a2a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73873bdd8ac8c7c485b023b292095eb410acacef4b1c0db5a6678889078914b0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
