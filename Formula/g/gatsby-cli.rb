require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-5.12.1.tgz"
  sha256 "06d2ef6efca4d0af2abb72cee244db7714d468f7249804c4ebb7abc8f0812c24"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "97a8334bc0871883b779f908d4e50a128432f2288698881f50d4a33267ded1d1"
    sha256                               arm64_monterey: "6538d29f74e28b91086c6fa452b67cee54d6bcbbe4b9aa5571164e03dbda0fd8"
    sha256                               arm64_big_sur:  "b9e9ef64f6eb7c35ccd05b6db2f3ae802a5ecc1d318cae8dbeb77d98a1c0d1c8"
    sha256                               ventura:        "29bac5d299062af44548edb55e67c86dec6fc68ca74cfa7e3b4c804b9090968a"
    sha256                               monterey:       "93734697b23031d3df7b9dbc4223aa5dc8cec1e3e74a41ae254e23b9f28b0777"
    sha256                               big_sur:        "88f8f86428c7164427e9199b7a05ce485927ac0b56e6f96cbc45ccd36d330cca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cba73665fda0f63b1acef5fac6eb081c57489abbcb6be2450950f2f99e6a00a"
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
