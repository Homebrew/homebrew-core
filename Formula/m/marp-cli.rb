class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-4.4.0.tgz"
  sha256 "564ffe54b62b5a0cd7c07dc69d6bc6bd1f4443e9a04256c9a1e0bc4ba9e6b24c"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "b736b6057fbd2362e98098260ea5f7a4bc45083811f7a4416b64ef7ec2aae4e8"
    sha256 cellar: :any,                 arm64_sequoia: "1022c802fe2927d93d68153550089cd61706c6694fa7c29f30f003d8d1b5e908"
    sha256 cellar: :any,                 arm64_sonoma:  "1022c802fe2927d93d68153550089cd61706c6694fa7c29f30f003d8d1b5e908"
    sha256 cellar: :any,                 sonoma:        "cbf7d9124137a38d4b9c67d7a752d3536b11fa0d2a8c72d83ebe8e4ac12e2344"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff3c7f6fdf1cc304498e76b34cfeb40b72d9f7d0be28f9814793607400f0031d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd0296008c2e6062bc4e1774188cbc676c67b4c7f79875b164ea943f8e665a31"
  end

  depends_on "node@24"

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
