require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.20.0.tgz"
  sha256 "7a3f695f1e9acb3e923b31b500756b3f81f0aec76b72b2ebacf6a8308301b421"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "0d5b2d2a886095a1f294dc36f719b71e1befbd3bebac2d03d21b0168112705d1"
    sha256                               arm64_ventura:  "6114d1d903cab8544c54424e745d528367fcf42e59a39636f443deea02b6ca5a"
    sha256                               arm64_monterey: "9cc6ba87f7401e0011e16f5c1368d09a8904bfee1b338aabbc49bc26caa969b9"
    sha256                               sonoma:         "a1a545baf1c18e8c1cfe7360908da3be4ccd4229ee0a625803bd382e0c37656c"
    sha256                               ventura:        "9adf085c968619b38e3b5d201613991fe794803d3097cd5e802fb769dcf119d4"
    sha256                               monterey:       "d941532aad62a601a14c18e43193f18488aa96912fc422bf073a8652b92d2bcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf0510608d6513f0ac65fee0b6fbf92e692c95ed63c9750ee08c1ae253a3625a"
  end

  depends_on "node"

  on_linux do
    depends_on "vips"
    depends_on "xsel"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/netlify-cli/node_modules"

    if OS.linux?
      (node_modules/"@lmdb/lmdb-linux-x64").glob("*.musl.node").map(&:unlink)
      (node_modules/"@msgpackr-extract/msgpackr-extract-linux-x64").glob("*.musl.node").map(&:unlink)
    end

    clipboardy_fallbacks_dir = node_modules/"clipboardy/fallbacks"
    clipboardy_fallbacks_dir.rmtree # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end

    # Remove incompatible pre-built `bare-fs`/`bare-os` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os}/prebuilds/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end
