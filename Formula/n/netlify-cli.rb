class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-20.0.3.tgz"
  sha256 "a5c80c5049cb37642eab505f8bc2c8c2947d0c336f3a714f3517bd31e7f7b97d"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "012a1e65fc3287970b3e7cfa3abd8a87acdd9bbf6a1c34a48e30ace14697ab95"
    sha256                               arm64_sonoma:  "4eb0eace76948504fbfc6938e7044e8215080ec90e27dc3f0d89719a477cdeff"
    sha256                               arm64_ventura: "861b0e2a08e5c9101b82eadff4e8a338be99cc4d0a04f426c68bed798dde1e9a"
    sha256                               sonoma:        "04e6581070dfffc88a3de4825e09e855e59cb5eaa0b41ad5d65fcbcbb089a165"
    sha256                               ventura:       "1c036866d04d047b41081cab06634867603b5b33797a374702e379fba1543ae6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c5cd548c91f8b6a0ed7025db8460d92e3b217e9c2a64141d620eeaa53232262"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4832e8d0871cb01d7ee41d16fc3ddcef7a783af28d1013c206a8b22b3d755d7"
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
