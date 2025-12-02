class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.18.4.tgz"
  sha256 "5c749095b6d9d306600dfb8962bcc7f959bfc76b00b53fa0b3d072150a574b85"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12dd9db1b2f4acd0248a00eb0c73f32de84e1da284cb61d63fd479ff5647d47f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12dd9db1b2f4acd0248a00eb0c73f32de84e1da284cb61d63fd479ff5647d47f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12dd9db1b2f4acd0248a00eb0c73f32de84e1da284cb61d63fd479ff5647d47f"
    sha256 cellar: :any_skip_relocation, sonoma:        "510d8753c5bb293ab1d248cf48476890b8f8d6ac71a4ce856598ad73452cd8e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc4a374002883f6547fe0334d2049b2c665bc842595e64eefc8f29c2a8576a3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "724c5102cbdca83b1ec2ddf1c8b48d9de557136dcc35a0930407a397d07f1732"
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
    libexec.glob("#{node_modules}/tree-sitter-bash/prebuilds/*")
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

    assert_match "Please set an Auth method", shell_output("#{bin}/gemini --prompt Homebrew 2>&1", 1)
  end
end
