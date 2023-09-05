require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-5.12.0.tgz"
  sha256 "bf0ffa00842d097dd513e8cdc9c4de8c587dfef62ac2637dbf6aae7e6cf0d575"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "5d24a8cafd5c034cc03ce215bb1ddc6fc548af304ec04431877d51bf6dd7d3d0"
    sha256                               arm64_monterey: "f720c3787136c8e6cdf6c5bb33ff9c768c500c36e8b6c107774cd3f5a94a43c3"
    sha256                               arm64_big_sur:  "3447de50fe806ff15ab82bcdcb69f8d1bdeba44ebec1d94e222ec1ab4b4f89d7"
    sha256                               ventura:        "57d6e2af3bef478383d97f0d6d520ea3db564be292472a85ff9adea57ca49d28"
    sha256                               monterey:       "3eb74dd25bfa5b2a0c8d671fdb7f9008b1d09f9ae09481f2c597d1ee9b38f5a2"
    sha256                               big_sur:        "501a7ef2001babc26b759345754f7f33918b1428a01d7586e92e765ed444abc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e47ac10c35ff006481699bb01412e2b8f466d7e660a8b2a157ae3abad5431886"
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
