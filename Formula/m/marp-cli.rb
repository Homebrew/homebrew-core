class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-4.5.1.tgz"
  sha256 "d7702c0cc55af571cc8085c1948fb21d67f57f547a6b3f2793e27a73e677dce9"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4acc726c328ffd8ae8448c76c311603bf34d691e987bffdc36c084a2c4d80197"
    sha256 cellar: :any, arm64_tahoe:       "ca228213ef15e6ab368ce1a73b766c24a89fdd8f0370f4d7dd2899cb41f1288c"
    sha256 cellar: :any, arm64_sequoia:     "ca228213ef15e6ab368ce1a73b766c24a89fdd8f0370f4d7dd2899cb41f1288c"
    sha256 cellar: :any, arm64_sonoma:      "ca228213ef15e6ab368ce1a73b766c24a89fdd8f0370f4d7dd2899cb41f1288c"
    sha256 cellar: :any, arm64_linux:       "149ac5cea6e5f836b86e4b301b5e5184d87ffdcb8be7085a99dd4fad2aa68933"
    sha256 cellar: :any, x86_64_linux:      "5d3ce9855ec8080a560a61d6bd436cc1837e78dc20b20cc4492028907678d254"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@marp-team/marp-cli/node_modules"
    node_modules.glob("{bare-fs,bare-os,bare-path,bare-url}/prebuilds/*")
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
    assert_match '<h1 id="hello-homebrew">Hello, Homebrew!</h1>', content
    assert_match "background-color:blue", content
    assert_match "👍", content
  end
end
