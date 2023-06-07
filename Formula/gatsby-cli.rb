require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-5.10.0.tgz"
  sha256 "c860e3adb81d4d5678285d42480b63513a6ce6b704c39dd5d327391502e30067"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "d5da1c2d7c2c5545b80f832cdb5cdbf1a6a24daba80eee0d6739c00557a7645b"
    sha256                               arm64_monterey: "1dc1513cded54e594adce75ed1bcb3e1a45fe73edfb15216aae258ba6e042fd1"
    sha256                               arm64_big_sur:  "cde9392cb4d187db161763862b2c180d3ee3cd5a1b9a989b9862a8cf96ab12d2"
    sha256                               ventura:        "035e5850346d555601f9ba28be14a5c19b9e2372503ec88b67cdd6ae257953ad"
    sha256                               monterey:       "6da66d777496238eaf3675b31a1e0ba997f9ccd32fdb4a8898463529dce5bc95"
    sha256                               big_sur:        "11d05c0725459abf43576f6860d4d54cd213974906a64d13db0a83f9f66bbbaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ae3c7f49ab17ced0a169b10d43fd82d7cd4d15d671c371a3eb6d6d78aa06460"
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
