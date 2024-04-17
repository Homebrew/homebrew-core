require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.22.1.tgz"
  sha256 "fcad42a7ccf9579f9015ba5c984b270e18f057492f2a4b820228d28ab0155727"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "8b4f75f83773fcde72d16b0c01534380c43e14d8235af06566280122eb953623"
    sha256                               arm64_ventura:  "be29879dcf6d8878abd5f77db975a7f286f65147005c0d487cc60bfb95518c36"
    sha256                               arm64_monterey: "996a2e63617ceb7462f5f503e067df5fdb7fa4948fc7d7cc30905072534c3a30"
    sha256                               sonoma:         "0b0fb7d364b32c0637bda8f02e20281b1ff412c3bebbdf557ac67300f82d2422"
    sha256                               ventura:        "e95136c6446b34d4a91f89e5deff63cbbd5205045cf966abf5a449b42e54cd91"
    sha256                               monterey:       "202cef9182aaeeca7d4c32725e33787ce7378e3d5b3c7ecbd5e2a23b3b6ec0ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfd0f77793affdf08525435fb6f9a0bd82ee43d330cd1c26a7d5a385677f7751"
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
