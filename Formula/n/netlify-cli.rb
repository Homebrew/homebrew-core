class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.34.2.tgz"
  sha256 "86c8d66e253615d887cce1b8a4c79dc8fd241ee009a27e1cf929805f972332fe"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "8d90e2db188844198939205bbd9dfc3c8de579d80dc058c89b524aaaed660027"
    sha256                               arm64_ventura:  "c5c61c344e720214b936094c7ef9f89396e6a33baea272d5d61e8ab18daed8b2"
    sha256                               arm64_monterey: "1c164e209adb82369b91d3d4058d5fe7bc9d8b6cf2a43d9f399af936c084e716"
    sha256                               sonoma:         "0aaadc681f5fb4b6fb0809a4ac210b3985ebcbecdfc293b7f6aab1cdf5be25fc"
    sha256                               ventura:        "09d4ebeacbb983317632c5775ce896ea776bfa6571a2ea1fcc7e9d9388d7d9ea"
    sha256                               monterey:       "2dcf0ec2a1eb702c4a8f09a211391d285969790dfc80059edd797947b5cc60ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c228c129ec6c60e61377c30ca506f7a30785d839cc45647f42e060ef54cdc11"
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
