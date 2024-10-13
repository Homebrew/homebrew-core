class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.37.0.tgz"
  sha256 "22050dfd8249fc5f8cb50bb417751a8071c6f93027adf4e73cb76c7442201025"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "08adc3d6cfa09ac072aef3a4dde9238511b4c291a2b4f706ca2dde3528e656cd"
    sha256                               arm64_sonoma:  "77044e8d3fc75ae01ded7b83670b41e7eb781e99d2ac748a105ad49a3c27f85f"
    sha256                               arm64_ventura: "336f856fe9be7f72d68361874f0aed77c4cf0d9240d19374e5fd861917d2afc1"
    sha256                               sonoma:        "55019973d1a2c44ece269b19266c02251e7311336567279a69818a949254553b"
    sha256                               ventura:       "f7e59a968ec0d2830ddf5d4bb5eccb917da539be3c23fc38adf7a7e977851e3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6358c92be1394a929d67d09134965fb60aacf84605ba4ea63c6f97b5756fc512"
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
