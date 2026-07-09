class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-4.4.1.tgz"
  sha256 "7c471064870b4d591fc4e038210a415e873d534fc7ea16813c6b9f1ec61b7d1a"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "30efda718bde69f3eedaf1d3f04ea9ea00d17ab913ce135e0b983643bec35be8"
    sha256 cellar: :any, arm64_sequoia: "b949dd1016c8552c2ba07eaa10ad9a9316f16fac8e435180433dc6a08136a7e5"
    sha256 cellar: :any, arm64_sonoma:  "b949dd1016c8552c2ba07eaa10ad9a9316f16fac8e435180433dc6a08136a7e5"
    sha256 cellar: :any, sonoma:        "b1723e21ff0549195afdcd499d2a8646ae5aa58e7901ee7cd20f00312928b97c"
    sha256 cellar: :any, arm64_linux:   "d9ae09d583c502752bd316e2ae351da0117caaa6efdce6b616fc40c14cea16cf"
    sha256 cellar: :any, x86_64_linux:  "7b93dd21f0171f5f648db39d7c46fe9e17ea9954b0a2a263b8b0f1fda70cfdb0"
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
