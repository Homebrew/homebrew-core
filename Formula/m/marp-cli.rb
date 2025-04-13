class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-4.1.2.tgz"
  sha256 "6f7e20e66b12906be9e4ed7225621ccbd0bf02690b03716647103e64dadb1b84"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "da62b75e00504397c018a751576c1b783e7f6ba3929d0e9611fd53888614fcf3"
    sha256 cellar: :any,                 arm64_sonoma:  "da62b75e00504397c018a751576c1b783e7f6ba3929d0e9611fd53888614fcf3"
    sha256 cellar: :any,                 arm64_ventura: "da62b75e00504397c018a751576c1b783e7f6ba3929d0e9611fd53888614fcf3"
    sha256 cellar: :any,                 sonoma:        "c6155d61543ee99565db5b1ad20bb9124e38389d5306303c8ba7425f75de869c"
    sha256 cellar: :any,                 ventura:       "c6155d61543ee99565db5b1ad20bb9124e38389d5306303c8ba7425f75de869c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87c5fb7463b29b211d2af1e0a5e4e691e90868403b16475d2531f354a1724259"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c48d21a663d8d84bbb1be5da79a56a45148e22fdc67674fdee91bcc99de9ab3e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@marp-team/marp-cli/node_modules"
    node_modules.glob("{bare-fs,bare-os}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    (testpath/"deck.md").write <<~MARKDOWN
      ---
      theme: uncover
      ---

      # Hello, Homebrew!

      ---

      <!-- backgroundColor: blue -->

      # <!--fit--> :+1:
    MARKDOWN

    system bin/"marp", testpath/"deck.md", "-o", testpath/"deck.html"
    assert_path_exists testpath/"deck.html"
    content = (testpath/"deck.html").read
    assert_match "theme:uncover", content
    assert_match "<h1 id=\"hello-homebrew\">Hello, Homebrew!</h1>", content
    assert_match "background-color:blue", content
    assert_match "👍", content
  end
end
