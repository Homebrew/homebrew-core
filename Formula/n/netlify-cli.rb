require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.19.6.tgz"
  sha256 "d316edd1fd7433f8e4cdd215075b8a572d7bc6c94bbf76dd645a44a740306d7a"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "6c47035ae2e923fc6638256774b5716aa3d712be91ec4f372c1f5d4a809eb95c"
    sha256                               arm64_ventura:  "64044c206b9c1290735ff876132fdfeaa40c88fb6466a872fe40ca25ac4de9f6"
    sha256                               arm64_monterey: "e8f1eb629af52fbc4e70e05d2bcdbcd4bfc213f85cad8cd0a272eb6fa74acda2"
    sha256                               sonoma:         "e9f510e687527e2dc882869148e9bfec049abbfbb45950821921789da652f89f"
    sha256                               ventura:        "3d670dd720f257ee2259e2221fe8f66238c79d61546c93046e6079bda9bded27"
    sha256                               monterey:       "61cf4505af52b500ed6559c0c7d48fe04dfd584692b46077dfc41c891998c4a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bb6ecb389aa494d349153020fec90ed1a7fd84af92479b7c13bec2658c2538e"
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
