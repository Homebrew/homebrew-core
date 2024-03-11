require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.19.1.tgz"
  sha256 "7463dff82a3c17fe71fe6802f1220cc3a0e8e50bd218473524d8def123111979"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "6236d596b25fc840fd333bc9dc5011fb3256ea95a9e4dfef29808c3f545ed268"
    sha256                               arm64_ventura:  "23514ae5a744890cb37a444df65b13fcbcfab515e57b3c6a284b2f0ce884ec58"
    sha256                               arm64_monterey: "6a1bc5221e59d04dbb3a62c666e229e77fc25887109ddb5b959fa2a7d12dc0cd"
    sha256                               sonoma:         "f39571a35310bd3d56c13ad1fad639d22e36a1eff23b5d20d06ead57586cb631"
    sha256                               ventura:        "9f8b83e597cf60921624ef0bee8001b42d4f9d567e91109202ba40e02cf47194"
    sha256                               monterey:       "cfb16ef6e92700a78c9f0a01276cba2f2fb86c822f6c843ad148dc2672452d16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e478287357afcf7783ffbf1ad78fedf5d2c429700bd2d407bddbfe015645b174"
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
