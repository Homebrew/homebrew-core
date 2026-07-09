class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://geminicli.com"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.46.0.tgz"
  sha256 "0f36bcd29dcb69ac484427fad57006579b4b559f4b36ecbf893e9f960e1bbc40"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "6e21409a31d83c59b6f71a6a7ce3e658731ed26da7849c27d1f6b0a3b9836a95"
    sha256               arm64_sequoia: "9672e78ebb557fb594c8a1a39957dc66d347a3bc2345617fdd7e7736a19df930"
    sha256               arm64_sonoma:  "d7b5f4bee043481b7c598cfc522eec051774134811867a5e1e21be23d6519fb9"
    sha256               sonoma:        "7761e9a7fb0ffa6188f8cd22e56e6662c90ae97d2eb6355c7315b4d0fe4d885f"
    sha256 cellar: :any, arm64_linux:   "3702ce81a5cdc24c327e994939d33b5c0bdcaefc484e7018d3ab813c7d294e00"
    sha256 cellar: :any, x86_64_linux:  "b8235dc511bb2ded3b6272e0f018cdac02938f12637cd5549cc0e0ef2f88f640"
  end

  deprecate! date: "2026-06-18", because: :unsupported, replacement_cask: "antigravity-cli"
  disable! date: "2026-12-18", because: :unsupported, replacement_cask: "antigravity-cli"

  depends_on "node"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "glib"
    depends_on "libsecret"
  end

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

    cd node_modules/"@github/keytar" do
      rm_r "prebuilds"
      system "npm", "run", "build"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemini --version")

    assert_match "Please set an Auth method", shell_output("#{bin}/gemini --prompt Homebrew 2>&1", 41)
  end
end
