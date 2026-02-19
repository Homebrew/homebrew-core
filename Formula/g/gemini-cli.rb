class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.29.2.tgz"
  sha256 "32a766a7cec946e0642b679126da9ae11806ee955b8a6178069e5dec23ed5efe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f417fbb95b6f646b26db5dec026efbeb9b5a64edebc2618972b05d18ab603ad3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f417fbb95b6f646b26db5dec026efbeb9b5a64edebc2618972b05d18ab603ad3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f417fbb95b6f646b26db5dec026efbeb9b5a64edebc2618972b05d18ab603ad3"
    sha256 cellar: :any_skip_relocation, sonoma:        "81faaf0f200425d4945bf1c0bc7af49092fa24632278db2c80fa05d1e457904b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e6d72ad92ea0fb73868e156a31f02776aa99e1e2eb733b84d0bc06871a5814a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3eb3ff8f7b788bacb887d43bc545229b8f72d5e5485ae6b3632804e4817ec389"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@google/gemini-cli/node_modules"
    (node_modules/"tree-sitter-bash/prebuilds").glob("*")
      .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
    (node_modules/"node-pty/prebuilds").glob("*")
      .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/@google/#{name}/node_modules/clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemini --version")

    assert_match "Please set an Auth method", shell_output("#{bin}/gemini --prompt Homebrew 2>&1", 41)
  end
end
