require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-5.1.0.tgz"
  sha256 "4870a6a3e1b3c4b906dd59f34cfbaa9b37ff5952e4cd15b57aea3b0a1a9cdf83"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "0faabcb56a0162440ac647a0875d5a3273a7e7735c51a87b5331b6ddbd5e3d7c"
    sha256                               arm64_monterey: "14abe118dd584387be77c83e0daaa6f21500427eb5eb9dcf5af233809a732e47"
    sha256                               arm64_big_sur:  "a5c14e685c3db9ce83d08e4dcea2bcef145fe9b321cc91e8d7ded13ef206fb5c"
    sha256                               ventura:        "b95062c1cad6e22b17f9c886f6664897a5c1f5ba8adf4dbcc240a8878f2554dd"
    sha256                               monterey:       "38c69b175f696563b322f06a3208fe1b774a87836425546d4b9a8252896d2694"
    sha256                               big_sur:        "4fb6a93fddfcf91c50d34bf5050fcbfba4c1ce3357d2d0ec783dcc3414699aa2"
    sha256                               catalina:       "58483466617dfa5f7ecd2dcdc357a8d9abf03cd0c1f4589c7d649f6851d10165"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1475cca60099e1bca25005066e829e533c37e78c54a5572b9c992d0dad217d92"
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

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/#{name}/node_modules"
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    if OS.linux?
      %w[@lmdb/lmdb @msgpackr-extract/msgpackr-extract].each do |mod|
        node_modules.glob("#{mod}-linux-#{arch}/*.musl.node")
                    .map(&:unlink)
                    .empty? && raise("Unable to find #{mod} musl library to delete.")
      end
    end

    term_size_vendor_dir = node_modules/"term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries
    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir
    end

    clipboardy_fallbacks_dir = node_modules/"clipboardy/fallbacks"
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
