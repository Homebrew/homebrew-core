class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-4.2.3.tgz"
  sha256 "e5851716df96b0d5fbe3216e38b1f0ce8f7c6ea0bd1c00e712e77d9da56a2bc8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7af2e65036c931e145ac5239ceb623be4c743d0304fb30845d4299bdcce010af"
    sha256 cellar: :any,                 arm64_sequoia: "afe20fa2d2bc1e72cab303a06aa1764a261b3f277af69754c2fbb364e8c0f682"
    sha256 cellar: :any,                 arm64_sonoma:  "afe20fa2d2bc1e72cab303a06aa1764a261b3f277af69754c2fbb364e8c0f682"
    sha256 cellar: :any,                 arm64_ventura: "afe20fa2d2bc1e72cab303a06aa1764a261b3f277af69754c2fbb364e8c0f682"
    sha256 cellar: :any,                 sonoma:        "97c290b4a650c3b421a60e2fce7dd52e9afbc302032e0b01ad232f9c42f3c3da"
    sha256 cellar: :any,                 ventura:       "97c290b4a650c3b421a60e2fce7dd52e9afbc302032e0b01ad232f9c42f3c3da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db42f2fae93fcc70faab4be230c1c1a8dcdf1d625bcafa6e9db9c3adda32c06f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c18593d51a84e812d5bdba8784633a0a80f2e7cac84db0f915a7b7804fdcae7d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@marp-team/marp-cli/node_modules"
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
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
