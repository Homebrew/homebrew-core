class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-4.0.0.tgz"
  sha256 "702bd87d608ac9a7fb7c1e728a51392f4210b0b0b64e8a3f9e37130bce7ced48"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4de9cc98ed0204fc0c9bdf8fdad64efbe61ec97f18014fa8b6df0a37e5e05bad"
    sha256 cellar: :any,                 arm64_sonoma:  "4de9cc98ed0204fc0c9bdf8fdad64efbe61ec97f18014fa8b6df0a37e5e05bad"
    sha256 cellar: :any,                 arm64_ventura: "4de9cc98ed0204fc0c9bdf8fdad64efbe61ec97f18014fa8b6df0a37e5e05bad"
    sha256                               sonoma:        "54c68d1ff8c79bdf0e4c24f5dadb3e65f52c6209b59152ab59131cbc902596d0"
    sha256                               ventura:       "54c68d1ff8c79bdf0e4c24f5dadb3e65f52c6209b59152ab59131cbc902596d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8c0ff2e38c4c0ba768da4a5398f55c150283ae3e3ec2cfe2039ab1b54db2546"
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
