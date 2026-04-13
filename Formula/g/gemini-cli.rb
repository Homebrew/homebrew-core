class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.37.1.tgz"
  sha256 "14a663bd41213590d65dfca795462532910bf24035ca70335e63a2bbb7c5b7ad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "404a5b4b337114bd3b23cf8715495152908ba6f2d16cd558b1a3ea058c7d3474"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "404a5b4b337114bd3b23cf8715495152908ba6f2d16cd558b1a3ea058c7d3474"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "404a5b4b337114bd3b23cf8715495152908ba6f2d16cd558b1a3ea058c7d3474"
    sha256 cellar: :any_skip_relocation, sonoma:        "662d96d083a2a70b3b14528df496fee1a64a0136aba064f2619e4b23fb816c6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e48192c534deec5e05574f52a6d97687994d4e1cf8049cdd7de5ee957d69d70e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eef586fe47b5f88579464bcac796a431b8a1134028f41af9e6c3a6bbe629bdd9"
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
