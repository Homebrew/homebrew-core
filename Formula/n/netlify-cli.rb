class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.37.1.tgz"
  sha256 "b6b2c560dadac909e198bb388138e4a82d97a83db485e5fdd0ec374c4ed4ead9"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "334406663f56ae25c9bd84cbcc38408d25a6869269378d49debc120a6afba68e"
    sha256                               arm64_sonoma:  "3b11e0747a2e76071c63bc23e0e34fa750acc21726eb37f996c54e8cbe339022"
    sha256                               arm64_ventura: "0abfcdfb9ed685cad7096ad57b3b8dfb148c6f8aa5ac02a87bb43883ea63baf9"
    sha256                               sonoma:        "a5de1f5adf663da53aaf803a0c1b46bdf50c6fd11f13ece54f52d3274cf126f2"
    sha256                               ventura:       "91e10c6f6f99a0deecee77b65cc67f769043bdc5cf3f305938a30865c69d95d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a81c8f0c637fac25aa78ddfad3a44d079fb09e19c7d45063f87f99438534e9cd"
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
