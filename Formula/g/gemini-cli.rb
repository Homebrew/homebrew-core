class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.25.0.tgz"
  sha256 "b1afba002edf8d8de3f36a4df2772716ca8001fc806cb7570f6c61d4b034b3f6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d66450b26e4ed99ccf42c0d4d6750eb6abd5af1bfc72339c47e536991723bbc8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d66450b26e4ed99ccf42c0d4d6750eb6abd5af1bfc72339c47e536991723bbc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d66450b26e4ed99ccf42c0d4d6750eb6abd5af1bfc72339c47e536991723bbc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0ba676d6ddfeb372ab2d1595e81290239d22811a3f4fab3ee6adab70309c64b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5e960d104c8a9644c4dc841a83a2743d0b0f3a9959ea4623e8864bd8cbdd546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afe86da88bd405cd473d72fd62c24ef72485ce5cabbe80d1dee7b90db519acfd"
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
