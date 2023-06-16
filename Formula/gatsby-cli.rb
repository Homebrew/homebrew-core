require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-5.11.0.tgz"
  sha256 "b3aa3cdfb46e272def18a9e2e9548829eb5dc5a4fb53d76cdcc4cfd8682fd8d9"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "4e72a28774cb3528fab5305b281d03b7e74e8f3032e454ac4abc18d012b0919a"
    sha256                               arm64_monterey: "8fbcfb617d254e94ca843ee9b2d4914775a5edd45a3ef3c7b082152474ecbefc"
    sha256                               arm64_big_sur:  "38938120336210bb2667fbc214164b939acd29169e4a7b421eb719c3e8ff84b8"
    sha256                               ventura:        "745b649f9a02f62041666d68a9553dffe455ab8683a2b8a5cde7f7ffa78e12c9"
    sha256                               monterey:       "8a6b9e6c37b1b104a57d2d8c961996501a53caa73a199d85f1fa389c795bf56f"
    sha256                               big_sur:        "1a35ed5fbbd8b8ad3101c5709686288fff36c4eebff6e0be353f83b1dd407c14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7193f910d09aa71815ebfbcd943e248735a61708f89b7131ec33424c23f045c"
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
