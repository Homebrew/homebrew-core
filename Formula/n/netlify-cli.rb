require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.23.2.tgz"
  sha256 "27ca361b814f1a8bcbce76420a5551bd70a05fb37509305485b21d5982d585fa"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "965ca0c217b8d65439c0759e98235ce6131301e29b58e844fec07591c688c9e0"
    sha256                               arm64_ventura:  "6c0ec8feb8d6b25e430decc22d1aae24d8856e3bd176b996f0f38589c2c475eb"
    sha256                               arm64_monterey: "18542734f57aa02c9f44ea1a51620d3d2e2a8afa9330f56d62a30a289415ee69"
    sha256                               sonoma:         "81cc812a47b5c91b33fb69c8af85167deab43b18bbe7664ce32e906e1ff52d4d"
    sha256                               ventura:        "ff129e4e7f8eb1d4edab8e9fd243952bdc65110023da9bdb30ac1dc835cacfaa"
    sha256                               monterey:       "5a2b90d742ee280d77af5100eed35fc0626e186ca7ffe828b5ac6ceae5259e8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af45a9dac2a842151458997edcee27bc3d202af6dbb746e962c360806120ea8d"
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
