require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-5.13.1.tgz"
  sha256 "8348c9ee3cd750262820ef59221e85e1fb34b4a19584f0111bd1ae5c89a1b12c"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "c3beff2c9f320781b7554d7c1be592f129c65f9dd2f0c6072aa78f8b49de7e2a"
    sha256                               arm64_ventura:  "2bde0840b6aa45f275bf8597e935cd8bbf02d380e88673f6b22bdb56278d19fa"
    sha256                               arm64_monterey: "c9ddbd959f80c358467639f38885bba9e0a6c11e561e06bca8f6989b1ab3f443"
    sha256                               sonoma:         "c2c914f4014cea6b7e771048cbb94d56d707d629822464413198d52e463e9b14"
    sha256                               ventura:        "b96b4cfe5920602464dddfdba7c0367ee40a228f01bb6bcea20fd2153209c9ed"
    sha256                               monterey:       "4d738583f8a77843781e37af611b4fbd97abc3ccaa52e12d9fbbd15288a03198"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad2db1e7f28e6f3b390fee640e4f51aae603c5553434988b5b950a010c19b141"
  end

  depends_on "node"

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
