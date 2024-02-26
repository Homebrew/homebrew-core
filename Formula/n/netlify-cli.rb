require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.17.0.tgz"
  sha256 "d08111163ff564beb55e02dc1ced8ab04db8cd383074384fd92395c008a87070"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "516899e885618f3f8d7c49aa8517e395667b60b4a1e465436295ea93d1170ac3"
    sha256                               arm64_ventura:  "407534d692fe631dc32669e976f20aa2174b8529f18d82c008d38d64dd28392b"
    sha256                               arm64_monterey: "4962b87166e37b6023e2a58432813d714bf0e1fecfe50a4279b4944623b3c120"
    sha256                               sonoma:         "2e7bc5a20e9eb55f04d49ae16eb8d3500e869f3b4be91f27e93c09cb272ff1af"
    sha256                               ventura:        "cb2d13a7103cf52dac70cd5712c9c5b8f832deee031e9abe111f04f24e6f7916"
    sha256                               monterey:       "464bed6ebddf85851df7af6a5b0a4926cb66bb100f16d4da64f44a4f9f201706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c9b71aaf45c89115835197f41144b0f135624717d2afd3b7236b034a33b0387"
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
