require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-5.4.0.tgz"
  sha256 "1c33aa8e77ce96782df64dd20919b6cf4104a58bd32e6decce010027b679e720"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "8843751c65568b07fbec3973174fb7a58880fadc20449d253404f9cd7ce31f17"
    sha256                               arm64_monterey: "fd73cf679114f52bb4cfcede0bb93706ee7d76d71d809fb2093d836515b30255"
    sha256                               arm64_big_sur:  "394dc9711b661c907939e37c9ce650210ae5ca008d0fa8c79dd0322040806233"
    sha256                               ventura:        "0ea0f88acd741f2e1ae279cdb18c11baa876b934d11506c95f5eb924ca3e218a"
    sha256                               monterey:       "42cb093924abb3591b39f3126c8a2be9f66acd2c513ef65b8df5be3462d0f385"
    sha256                               big_sur:        "90986fdbe1a022d77d90124c251e7aea04b38bf2679c7cbb895fb622a9cd2308"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b4372d3dc0197d2d20796050fa483d8467e8594cbe29e9d95c610ca63ecbd8e"
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
