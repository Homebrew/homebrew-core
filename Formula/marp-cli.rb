require "language/node"

class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-2.1.2.tgz"
  sha256 "cd8acb76d3d7a5f1cf128c5504a0861dbe86fbb22f83b664c290c1b00e1c9c16"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b914d92b077303314f8ee0405441d6edb79e5eaaa21ee12b601b6c8bf0170980"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b914d92b077303314f8ee0405441d6edb79e5eaaa21ee12b601b6c8bf0170980"
    sha256 cellar: :any_skip_relocation, monterey:       "3a64a566614b4e64d03bbf3154e70ba0257bef271d68f9baeb688337f23d8cac"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a64a566614b4e64d03bbf3154e70ba0257bef271d68f9baeb688337f23d8cac"
    sha256 cellar: :any_skip_relocation, catalina:       "3a64a566614b4e64d03bbf3154e70ba0257bef271d68f9baeb688337f23d8cac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a69865e0f80e426a4077bdbd1ca601003d40487e919da8a60c2b4f4d144ae76"
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
