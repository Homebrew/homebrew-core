class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.42.0.tgz"
  sha256 "c809dcd0d68ac9f105e88b796069b947cb434d6860ac4acfdf304bda7fd30a8f"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "439d194db033d12c67a5a68ae7f9eb064a94e350353edf4a6b42f0109a6aa106"
    sha256                               arm64_sequoia: "2d55c84b054c6e160347e4ea20f991a92f9330e84b15a6ee14d2c303c4daffe3"
    sha256                               arm64_sonoma:  "8f6dabbff06a9a82d2b60e37bd31fecbcd7f0fed55fc7d5eb75f26de7c88bd5b"
    sha256                               sonoma:        "af44a5778d7e3cbd11c0313a040940d3665516e041889f0e86ec4a293693a3de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0da891ef34aa25e7c0180acbe804a4fb0daf4d7d925330c8159dd4caf75438c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27a2575e2e656637dbf33cae716de2efc0c6c282394daae9e18cb91634e77f6f"
  end

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
