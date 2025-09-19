class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.6.0.tgz"
  sha256 "74538f4c3945d2720697721f79caa87cf8316c84e477f4224e405ed198d1e723"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "405f165673129866ada8dedd5028d8dffbb849b96d0997337a643de21b5f11e1"
    sha256                               arm64_sequoia: "675a2d89d99325873ad65f050a59ab218c6e6076463760454744fbd7c5077c38"
    sha256                               arm64_sonoma:  "b327ce2b2f73c911a6217c9d2a89b9b4a746044e71e89e2cc3446a1727bd9ac1"
    sha256                               sonoma:        "ccdcaf43327ecabcfec377c21c9b9ce0b8aa2a20e52c62b1e87e3d756b900f93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5151ea860123fd0c64dd2df61186119a3437a532040527a4e22890d7237d3663"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49a93c0ee8342c8a161f8fc47356a39e2aecdd74b37ff171487965da83b8b5da"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "node"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
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
    assert_match "Not logged in. Please log in to see project status.", shell_output("#{bin}/netlify status")
  end
end
