class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.22.2.tgz"
  sha256 "d1c8d8458875a92a2773478875d7ede4bdc5276fc674e95518086fe7cb942334"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb841ccc9de09ae1c99019376de7760394136333c5ede682a709888f60f7bb0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb841ccc9de09ae1c99019376de7760394136333c5ede682a709888f60f7bb0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb841ccc9de09ae1c99019376de7760394136333c5ede682a709888f60f7bb0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "214b662bea40ba8d558d70b5a2e4b90250e4663e01f625191e862de47b82b442"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aec4b61326ad4bd5a71432aa05439d081e2cadb3c326f5823e4a29db3155395f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14810eea0656750901ffa662f4a04b2af49eb3013cd0811c1a93b08c76e462fd"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

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
