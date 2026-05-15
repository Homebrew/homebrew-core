class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-4.4.0.tgz"
  sha256 "564ffe54b62b5a0cd7c07dc69d6bc6bd1f4443e9a04256c9a1e0bc4ba9e6b24c"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "7184f11832c79e45e0e4fb35e161b11dfc8710043b5d032ad97ccde3745ce41c"
    sha256 cellar: :any,                 arm64_sequoia: "0becc63a887acace3fb76abddc37a396a916fc617b3709056fb18119f54743d4"
    sha256 cellar: :any,                 arm64_sonoma:  "0becc63a887acace3fb76abddc37a396a916fc617b3709056fb18119f54743d4"
    sha256 cellar: :any,                 sonoma:        "93409a22c28dc94865c581b99b72dbda134b2c560565edeaebdb2c681b8b250f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e133b0e595c3d74725c96d3197f1b91f1a050f071eb72d0e68ad0e600b524eff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "984c8825484b69b885583b5160e83ab24680cea8438ae8d1b2c24ab03611275e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

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
    assert_match '<h1 id="hello-homebrew">Hello, Homebrew!</h1>', content
    assert_match "background-color:blue", content
    assert_match "👍", content
  end
end
