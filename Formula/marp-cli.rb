require "language/node"

class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-2.0.3.tgz"
  sha256 "1e514d61b18794bd4a2d69d83417f1bcdc129a10a5bed5b29afb9840aefab545"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "916589d813035b1e4e669d14a25e14c205ae444b7efc922bd66e74a12e87fe11"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "916589d813035b1e4e669d14a25e14c205ae444b7efc922bd66e74a12e87fe11"
    sha256 cellar: :any_skip_relocation, monterey:       "a86520342e4513e4d13c8d25946537d52a420ab29b93e50ae914169ce2973d7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a86520342e4513e4d13c8d25946537d52a420ab29b93e50ae914169ce2973d7b"
    sha256 cellar: :any_skip_relocation, catalina:       "a86520342e4513e4d13c8d25946537d52a420ab29b93e50ae914169ce2973d7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "828d17a30eef236062f38c575cd0c7aade458c6ba58139d811f97a0d962d2066"
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
