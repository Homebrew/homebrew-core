require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.21.1.tgz"
  sha256 "cc6b96fa56e25df93ce3b70ba7537ab9fc6de81932d148e2bc4af7a01ebe3e40"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "b5c6b1e51ba2be7eb9630ae5ed9f8dec321efd98dab7bccf611dd6861b850fb6"
    sha256                               arm64_ventura:  "7367314c9bc713f095c8d1b58c422f6aee99468622fed3081dff00bb21aea1b6"
    sha256                               arm64_monterey: "0a435b950a747748c04d697053182f07f29194883ae133292bd3a84e3111ede7"
    sha256                               sonoma:         "d225bc079630571cf833bb58d6cd0b26cb81512173e0a081516cd51943876935"
    sha256                               ventura:        "2e3bb68ab440a9b04648ed2c6323253a3b786261b9dd78688eb15b04e609af6d"
    sha256                               monterey:       "b6589feadfe0fa3af738e5e248229d764ea0b80ff6d1a78b694e5877681dd6be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fad9f782b1511d2e3dc0c621277097b0dd9fe283d73a9624d0d15c3b6c783a9"
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
