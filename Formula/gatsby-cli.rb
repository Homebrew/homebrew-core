require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-5.9.0.tgz"
  sha256 "74984d02908162e22783327bfabf3a94ff4a7db33d4545dfa160d69c4a2de72b"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "e9922b031c0c055b3dd02625ee4839c5b99a83a9cb9243757d0473d6a908378c"
    sha256                               arm64_monterey: "056c629449224538220fb12254fd987323438ad1aec2894977e1cf42fc34057a"
    sha256                               arm64_big_sur:  "920915b9ceb8d348b16ee4ec010104c6b6a49c579e57447b31725808ba817c73"
    sha256                               ventura:        "2901a39ca627321a891c60983a59d7ad2290de621c5c2565e4cdca783fbdf3cf"
    sha256                               monterey:       "0cef6ab183ce9a213ff0308f81324fcc3aef6b9104a3696cfd1b21e29504a18c"
    sha256                               big_sur:        "2928d8ab1c6e79624a2c94c1552bce9d58bd6e81340defa354b6ad9463289dbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ebf154ae726996dce3b44584bfd03aa86d3c77063603fc0c7129417133a1381"
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
