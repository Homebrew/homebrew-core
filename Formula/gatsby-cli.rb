require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-4.1.0.tgz"
  sha256 "5756b79710b9f5be3d9eb2ff76acd3f815eb956eea480930d4d948d5a3837459"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1aec72d70654d908d3812fce152d59a727f5147c1594edd7513d16e67586a499"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a874771802d6d9bc3995c641eb436f478b8385c137c38301b91987c5fa9eedb"
    sha256 cellar: :any_skip_relocation, monterey:       "1862d09e7ce05b88312101e98f02f5791b07fc72033e3da8c2c7a91bceefbf9f"
    sha256 cellar: :any_skip_relocation, big_sur:        "1862d09e7ce05b88312101e98f02f5791b07fc72033e3da8c2c7a91bceefbf9f"
    sha256 cellar: :any_skip_relocation, catalina:       "1862d09e7ce05b88312101e98f02f5791b07fc72033e3da8c2c7a91bceefbf9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "688328738da70c4b723d08ed6f2bc3ddd844ba60712cc17a30198e82f08b67d2"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    # Avoid references to Homebrew shims
    rm_f libexec/"lib/node_modules/gatsby-cli/node_modules/websocket/builderror.log"

    term_size_vendor_dir = libexec/"lib/node_modules/#{name}/node_modules/term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries
    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir
    end

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/#{name}/node_modules/clipboardy/fallbacks"
    clipboardy_fallbacks_dir.rmtree # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
