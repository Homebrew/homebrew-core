class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.22.1.tgz"
  sha256 "de1225ce9a503616fec71068ebebc7ac03cd5455e1cbaf470b14beea0392b54c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9de331b9245f1310d3f1af3b1660f09bef391d372e20ad58f4d3e625e00daa1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9de331b9245f1310d3f1af3b1660f09bef391d372e20ad58f4d3e625e00daa1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9de331b9245f1310d3f1af3b1660f09bef391d372e20ad58f4d3e625e00daa1"
    sha256 cellar: :any_skip_relocation, sonoma:        "525ff427a6300e010491ceb6d0a0a75f0c312aaaa4ed212906d3d8b2b017620b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83ef405729830f68beaddf9bf0671481e6a260e028ce86f3c607a5abf13f06fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00237a8674e71565850a7267757777fb07756cb0d4515193ea27ddbfff3130b8"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@google/gemini-cli/node_modules"
    libexec.glob("#{node_modules}/tree-sitter-bash/prebuilds/*")
           .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemini --version")

    assert_match "Please set an Auth method", shell_output("#{bin}/gemini --prompt Homebrew 2>&1", 41)
  end
end
