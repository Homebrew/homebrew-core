require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.21.0.tgz"
  sha256 "440477d0e405d9dee1771e6f913116c53bbc15910d94b7079743dc584a76c5aa"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "6792b6ebb75c6cb026c0dfe7d5227aa3fd01d99eba206553a776344d8db43ced"
    sha256                               arm64_ventura:  "73dd79b55fa97deeba77caf1a7a2136e786083eaa76da93a2f4b5462abbae314"
    sha256                               arm64_monterey: "677d2aa6e05931e5873ecee5ed885aea9871f1328ebd64ee463e84f4aa3cbe7b"
    sha256                               sonoma:         "f214921acdef555af3bc270ab293d6782deda0e39ed2d1174f9307d4cc4e67cd"
    sha256                               ventura:        "947c3910b94616aefbf8f219f99831c1413fa35aede6b6b8a689c4b0ccf1eae2"
    sha256                               monterey:       "c064c1ab605b7cc21c247e0f553f573208bb94c8ecab5ecd73cc8f1fa199d57c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "865998631f2c5d9bf7feece96b7b64141be53c95a1de9c0b1b70229a0df3e722"
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
