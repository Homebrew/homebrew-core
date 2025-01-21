class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-4.1.1.tgz"
  sha256 "f2ccd943378f35f1a685a9de3f7da699dac84c46a0db429b495fdc26d77785f8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "acd7c96dad6d22f298ca016028293b6fcabab0d0065964f7f7231f6df42b9b28"
    sha256 cellar: :any,                 arm64_sonoma:  "acd7c96dad6d22f298ca016028293b6fcabab0d0065964f7f7231f6df42b9b28"
    sha256 cellar: :any,                 arm64_ventura: "acd7c96dad6d22f298ca016028293b6fcabab0d0065964f7f7231f6df42b9b28"
    sha256 cellar: :any,                 sonoma:        "ba901f13419206ed36a60be1a087edd59ddfb0806015aff209e8f183a4e9d927"
    sha256 cellar: :any,                 ventura:       "ba901f13419206ed36a60be1a087edd59ddfb0806015aff209e8f183a4e9d927"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "065ba330ba0cfb7103d31c25e1316187a5ebc40d8b564c58d220048671f1d8af"
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
    assert_predicate testpath/"deck.html", :exist?
    content = (testpath/"deck.html").read
    assert_match "theme:uncover", content
    assert_match "<h1 id=\"hello-homebrew\">Hello, Homebrew!</h1>", content
    assert_match "background-color:blue", content
    assert_match "👍", content
  end
end
