class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.38.2.tgz"
  sha256 "9b0c752cfe9375370e1812f37afffd97387b99df71e64cea53e588a25f4d688c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "469d65f595b507baef8cf349a363f2ef3844d0d89d805ebdf146707620616569"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "469d65f595b507baef8cf349a363f2ef3844d0d89d805ebdf146707620616569"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "469d65f595b507baef8cf349a363f2ef3844d0d89d805ebdf146707620616569"
    sha256 cellar: :any_skip_relocation, sonoma:        "07096f835e06edf9ccc591603c5a9f0ce7a3ae877eb6bc36ce79e9e007b6b922"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fcb15ae80ffe151cc65ba8f2fc92c34bc0e88fadef7d0c55c5cd88cbc063ca2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b351b6da6e4e35b234436c4cabb863f8a220d696ad85b19ee72c02acb61d4817"
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
