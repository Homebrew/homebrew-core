class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-18.0.3.tgz"
  sha256 "38260c1c01d8e3c894579fbbdc95dd3235b3cb654cd8c030a4766c2cf9323d92"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "38a70296e01197bf2835c3e03d1407b3fab05c7e28be1c8e6b3dad097870bc04"
    sha256                               arm64_sonoma:  "bb1b7b6cf730a1ae0cb5939b14a0687c057968033acea096593dbfc3ab0c0729"
    sha256                               arm64_ventura: "6bd73b719e499f7ba54615143c3e596d9006631b08d3921220b640c67d6e3fd0"
    sha256                               sonoma:        "b81b0195b3bc28649473fa68924f9d3aad766855712573dd0fa1bc78fcc229d2"
    sha256                               ventura:       "756081d80527433de98dad01f085d3de48ff0707f3352ab74d395f8dfd7d8427"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f393049156799b134f9bdff34bcc9bc2b7dc1cd9a8c91e6b6d1c01f42d2fc13e"
  end

  depends_on "node"

  on_linux do
    depends_on "glib"
    depends_on "gmp"
    depends_on "vips"
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/netlify-cli/node_modules"

    if OS.linux?
      (node_modules/"@lmdb/lmdb-linux-x64").glob("*.musl.node").map(&:unlink)
      (node_modules/"@msgpackr-extract/msgpackr-extract-linux-x64").glob("*.musl.node").map(&:unlink)
    end

    clipboardy_fallbacks_dir = node_modules/"clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
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
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end
