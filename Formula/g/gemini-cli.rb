class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.36.0-nightly.20260402.13ccc1645.tgz"
  version "0.36.0-nightly.20260402.13ccc1645"
  sha256 "6bd9ce42a1a3a146b2e02be2faa614f738b96e8bc7c4654e4b826198ee58d39b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a03001303770ab7fedb330d512a4d91e3051cfc51e47d9960f6998b27b1b437"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a03001303770ab7fedb330d512a4d91e3051cfc51e47d9960f6998b27b1b437"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a03001303770ab7fedb330d512a4d91e3051cfc51e47d9960f6998b27b1b437"
    sha256 cellar: :any_skip_relocation, sonoma:        "451d411d6fe6b4f4e01dd041d30fc78ba6134cc2de0394205efb5aab4497213b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52af2ecd49f3bc719109838099ffa01e03651513452a34113b5b0248c196831a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd80ed402b55b496bd523e55704f134e04d881a675a3960bbd7de928cfcfa459"
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
