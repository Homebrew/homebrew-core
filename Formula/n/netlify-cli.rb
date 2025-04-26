class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-20.1.1.tgz"
  sha256 "bd5b9b3661867be56f6e052381ba21c3bbe630da7f77acdf1593a97c531d89a6"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "1b3b52455e95c036b77407d9ddadc3ac839ed726418e5c3cfb723cb5d844670d"
    sha256                               arm64_sonoma:  "7078992f7b80e416a72d9908c9b5b857343d5f3bc7405a3f4bb16cc5c4bbfa2f"
    sha256                               arm64_ventura: "e26d532ed90b13138c3b6c5a274d97de4f0821548d2da75ae2b44ab7d8a4a8e5"
    sha256                               sonoma:        "543283635c4981a241b9280c886a9dde1a891f3ec38b5689662092efc8586142"
    sha256                               ventura:       "799a914ed2b2ecabb6b78340d960064ae1d7ceda762aec80c31e8c4c0e337f9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da54c078c834ac6cf2ce3fc93ad8d8ba330e401ae881dc33169e74ef80a3e036"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f0338e974738f7889128482a2992d45dbe2c34d2ff7bec9bdaf5c8f2da2f9df"
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
