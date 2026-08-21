class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-4.5.0.tgz"
  sha256 "36145f3400213afec408f8eff5dec2a3e5c5238201246d598019c5a5e4606d88"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "769b08ab2ca0825435b668c4e98388c71b0e34528e16cada97aa57d511e94b2c"
    sha256 cellar: :any, arm64_sequoia: "769b08ab2ca0825435b668c4e98388c71b0e34528e16cada97aa57d511e94b2c"
    sha256 cellar: :any, arm64_sonoma:  "769b08ab2ca0825435b668c4e98388c71b0e34528e16cada97aa57d511e94b2c"
    sha256 cellar: :any, sonoma:        "7f1aa3598ab5f1890cce23cfe6df91956b54df4edcd0c085819d279ae1b28c20"
    sha256 cellar: :any, arm64_linux:   "df40d9c2c44c498261d52624cab2d033c1f60741991f0c2b21b38381625a4b92"
    sha256 cellar: :any, x86_64_linux:  "805e71821bed529f1e5e645eb7f898da5ca18d84ce6f20fee9045aabefe32201"
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
