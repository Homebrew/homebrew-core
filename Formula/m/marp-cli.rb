class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-4.3.1.tgz"
  sha256 "162c5e06f022c75dd741f4e27bff8caf97f3283f3fa57475decea59d3b480a1e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b5e74d0cb2b6aba5ebc8fcb9066e2579143856e28565578344a0eec3177e7587"
    sha256 cellar: :any,                 arm64_sequoia: "f7bb739c27563361aa91847c952bf100f98167b6662d61d5a30999a8ba12c2c8"
    sha256 cellar: :any,                 arm64_sonoma:  "f7bb739c27563361aa91847c952bf100f98167b6662d61d5a30999a8ba12c2c8"
    sha256 cellar: :any,                 sonoma:        "f68e38630e584815a3b4035ff5f8dfdc6665b00aa3940b7e51d340e257c2c2c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "234404880ee4628830255bd83cb3f37e63798cd3a7c029e7b4edec22db135a9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c684a488cc5073a2783e8bff1575f60955763c96b4576912dd7f793395e6d11"
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
