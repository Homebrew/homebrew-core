require "language/node"

class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-3.3.1.tgz"
  sha256 "bef1fe6e62de5bbdf878bf32bbf84bc634b4cf8ef141a31b0fb869c65b7ac4c5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f3ef527f57e2a58af4315623ce5909557fd023ce35d938bbd6c75c61e2e08d06"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3ef527f57e2a58af4315623ce5909557fd023ce35d938bbd6c75c61e2e08d06"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3ef527f57e2a58af4315623ce5909557fd023ce35d938bbd6c75c61e2e08d06"
    sha256 cellar: :any_skip_relocation, sonoma:         "a51b18670ce443d52167ac37be98fdb88cc909c1e57930bdb69aba09c0b5e5e0"
    sha256 cellar: :any_skip_relocation, ventura:        "a51b18670ce443d52167ac37be98fdb88cc909c1e57930bdb69aba09c0b5e5e0"
    sha256 cellar: :any_skip_relocation, monterey:       "a51b18670ce443d52167ac37be98fdb88cc909c1e57930bdb69aba09c0b5e5e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3371788471156329c2883d6cb9fa1cecd25faa45c88b92bed703bcd36acde97d"
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
