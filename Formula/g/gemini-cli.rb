class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.37.0.tgz"
  sha256 "406445c0aa484a68faac3800b2e6b10eea07daf30f685ef6a63787d50ead16c4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb3e58d7a769677b2452d0349eb544bf7722f390a663119ed881850c13ce700d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb3e58d7a769677b2452d0349eb544bf7722f390a663119ed881850c13ce700d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb3e58d7a769677b2452d0349eb544bf7722f390a663119ed881850c13ce700d"
    sha256 cellar: :any_skip_relocation, sonoma:        "46cac4ee91173d29f05a6b5f7f16681750dc6165c14f93bbfd670e556c976986"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19ad4603c89f5d7b11e991c5930db65c6f7abfdee53ef331466e9d0de08d5ebc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c42aa865a13e4564db7571a7acdb9558033c4d400ccc325a67946b606c33f67d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@google/gemini-cli/node_modules"
    node_modules.glob("{bare-fs,bare-os,bare-url,tree-sitter-bash,node-pty}/prebuilds/*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemini --version")

    assert_match "Please set an Auth method", shell_output("#{bin}/gemini --prompt Homebrew 2>&1", 41)
  end
end
