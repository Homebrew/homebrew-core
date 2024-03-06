require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.18.1.tgz"
  sha256 "38dfc69f6620e1bfd5a7b0236fe5a801b893171790cee5b898a15f3a819cb1e1"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "bb4309920ff86c8551fd86d1ecea5c5c6c9d50c42be32843ebe873d0a5c08d65"
    sha256                               arm64_ventura:  "3ba49e6482c6d7930f0772c5112c52e86680209d6a1549354fe38ae62f875892"
    sha256                               arm64_monterey: "88947d1655447719d224c5fb7025cccaeb4d80c1a06510b787810db996d1308f"
    sha256                               sonoma:         "4d123a0df36d0e154d8b7071c1974777b7ca9e19c4e4ac1f9bf44dbc10cd010e"
    sha256                               ventura:        "8231abed3b32f0e8a792a9b529d42963a8172f8e17e4fb90aabd1493c3473ad1"
    sha256                               monterey:       "e0a442dd3715b3c7bc28598f03c5438aca5029682976fa867f13edc427f0c39e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "744be498f7d2a3fb401b5bfabcf1691097728166a91a92c217d2253a893da201"
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
      (node_modules/"@parcel/watcher-linux-x64-musl/watcher.node").unlink
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
