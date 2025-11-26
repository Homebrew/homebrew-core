class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.18.0.tgz"
  sha256 "0e24ac7424304a32a473ea05e2d7e7d49faf97d21e4c08d17842dbfca174ca92"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "eae560d29780cf7828630cb67b1797963899e53d0cf82e1bd511e5ad86d8e399"
    sha256                               arm64_sequoia: "617aa19eb40ff871fcd97b9b23d351edf9d894f93f27551a0b675cea8c7918c7"
    sha256                               arm64_sonoma:  "f3c19cf5de43ef87c0250efc76adbf11b9344d6aed67f036dd43a7dbeb1497c4"
    sha256                               sonoma:        "05c0b9834703ad811f8d1914d72bf1ab07a97ca60d558027aac21c38d0e6c76c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ababb7286a48da8d55520f60b3dec78548ea76a8e58990049d59601627145d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b1950afda3ee289f6d975758cd194e583721b7b2ad128917e85f6812b59b51b"
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
