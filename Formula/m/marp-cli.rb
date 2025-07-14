class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-4.2.0.tgz"
  sha256 "cc6ad9252588c05bd0dd8e74ab81a791df7e4cca7e33198237fd575005e68e27"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0348f4fa470cc682a28097048fbbdd1aec3606c9492eb278a3a4121320a27e23"
    sha256 cellar: :any,                 arm64_sonoma:  "0348f4fa470cc682a28097048fbbdd1aec3606c9492eb278a3a4121320a27e23"
    sha256 cellar: :any,                 arm64_ventura: "0348f4fa470cc682a28097048fbbdd1aec3606c9492eb278a3a4121320a27e23"
    sha256 cellar: :any,                 sonoma:        "455ca0aa496d062b289b70c9753bc712919d31fec176b830694e8ba7894dd4b4"
    sha256 cellar: :any,                 ventura:       "455ca0aa496d062b289b70c9753bc712919d31fec176b830694e8ba7894dd4b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43ef11b41d81ec796438455c2bce3c72d48717ffb03a71d45b14f2d7520693be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01aa03b5eff724585a86885eb5d26bda435ac6b90a84fc458ab195e067fc534c"
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
