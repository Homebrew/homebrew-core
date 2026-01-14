class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.24.0.tgz"
  sha256 "10908307b711b7dac287b07ce54093dac02d7446f9d357f83da2c24778cefde8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2421081f30845d35126eb147295e31360ec07c6c503b39ddf4b965240fb5fa38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2421081f30845d35126eb147295e31360ec07c6c503b39ddf4b965240fb5fa38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2421081f30845d35126eb147295e31360ec07c6c503b39ddf4b965240fb5fa38"
    sha256 cellar: :any_skip_relocation, sonoma:        "b90815c3611a6d13d48e553f1d08966c960d0bce380058cceb6f6882515d5241"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f30a59cdb0e8d11fd612ce16f377d1840f844d4f282257d63dfc20f9604cde0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6083c1e8208a0aa68850bcdabce6aa7ca5ffe6ad259ebbe63e4e563d82438d2"
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
