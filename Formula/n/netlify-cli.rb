require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.19.3.tgz"
  sha256 "1853378db0df4fb066c5cc2e88346893caac6cc86592b124569e0703930dbc38"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "0203a2c49168089a55010c648abe77fb8b8c0f18bd6d102fa8f085e1d4a9f554"
    sha256                               arm64_ventura:  "9c82468a4b64d4b34d1e451349d2a3de77d5d165471c5008465f7d6a5d846e26"
    sha256                               arm64_monterey: "bb52ac7243b51c735394a509622477d0369cb06a7f273e6609341a0afb5dbbd4"
    sha256                               sonoma:         "e59d89382908369996ab62bdd0cf352e732de1957dd9a8f799c76e36304c5fcc"
    sha256                               ventura:        "e91f2d6cc41cd2a9c0ca17fb31b2849e223719358a75cb2f3ff4ebb93740a848"
    sha256                               monterey:       "a37b2df728e7f80f59ab4c72456963c5a1221362ebf93248232515e0d6c32da6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71c000662f20298e74c941e4ebb376de0be26dcf8d79454a44ef80aabfc363c3"
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
