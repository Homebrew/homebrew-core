class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.34.0.tgz"
  sha256 "da35349ba092192f094e5616da3dd5320cbb84e31f8cbc3c817fc94fee825fa8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d7ca8fc0fa283836e3710f53d05de69cf2b9a3290c9367513b86b1d38a92da5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d7ca8fc0fa283836e3710f53d05de69cf2b9a3290c9367513b86b1d38a92da5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d7ca8fc0fa283836e3710f53d05de69cf2b9a3290c9367513b86b1d38a92da5"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e5348dd09311cbaa0b7ea451c415a1ef207ba400271b04c80b9d3ac7663cc0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b86542f99a9d93ae529f4c92738fb66aa4df8b2859c10f3ab24a7b4485e5610c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84efed3bcbf7f04d81addaac8b90625a477f0216d5381ec5c76feaae8b33f64b"
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
    (node_modules/"tree-sitter-bash/prebuilds").glob("*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
    (node_modules/"node-pty/prebuilds").glob("*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end

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
