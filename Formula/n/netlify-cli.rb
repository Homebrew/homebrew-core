require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.26.1.tgz"
  sha256 "0297629fe6156a1818d4b6c37b120c83451dd84c15a54b67a62f78f07ea5bfc9"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "00ddeec25540b9c0fd0fadb262bd3fada7cd9d62d9347e10be863ca4c73168c2"
    sha256                               arm64_ventura:  "9c5c5d1bbe5c5276973d9b7d2be8297d385f139788fd48c94eb724928980a640"
    sha256                               arm64_monterey: "97527b793d97ef2f62824975377b949d749a53412032b7e810b7472127fcb6b2"
    sha256                               sonoma:         "56c72921fed1391438cd9bc373840a227b7d4612d65c817265b3fdac57123869"
    sha256                               ventura:        "04a4001f3cf70f9956753db4d80aa3f888e776d88b4d7700cfb7755b7264c693"
    sha256                               monterey:       "a3e810a09c365d9bc790c3840be8501ef8a6a3faaee37974e55e113111c0009c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2aef89dc4fec503ef631e3b186632d0e56b2ddf84f3c6847ca9ee7c38c70df4"
  end

  depends_on "node"

  on_linux do
    depends_on "glib"
    depends_on "gmp"
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
