require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.19.1.tgz"
  sha256 "7463dff82a3c17fe71fe6802f1220cc3a0e8e50bd218473524d8def123111979"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "8045009e82c8d9ad5c5bff06dbf45a7501ba3072740cc11be1420cf2c9018768"
    sha256                               arm64_ventura:  "5ca71a00f52154b52a4a75d73efdc02ea0850a7a775431a8b8057f275d818c7f"
    sha256                               arm64_monterey: "39703f3c6a5c99865d2e43d951a0986ee557b4fb2d34cb5c95580e50642e9981"
    sha256                               sonoma:         "7d8d0acc63eb1cf7008b4e133b6414c7c987a594ba6f9f83a76f73cb4b908c14"
    sha256                               ventura:        "a7df3cbe071d5e07181a454ed142b71f5a27018820dab569af8d04d5c38ec484"
    sha256                               monterey:       "ba6e50de8db44522ee0ff93295f3c3cc573569fb988e853ab8071404f199e035"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0f8df0f456eb2291a2d431b688f9830382321b31465e6b4b59e006a851e4787"
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
