require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-4.16.0.tgz"
  sha256 "bc9136aa3433796227d1e4d0b61d37690ff360c386ed4de36ee051e561b2433e"
  license "MIT"

  bottle do
    sha256                               arm64_monterey: "e9c7b70fdf39f82f2e4b2a60fa15e9f1d481a1c0ba701a7a50610489765cf54e"
    sha256                               arm64_big_sur:  "449a69c69a135d74ed649eb9c1ae924272c673e676b5ab91e18d39a7d9d63ca3"
    sha256                               monterey:       "fc8ec3415bbca8c45b8b8eae4084a59bbdcd846e3c9e1f963b4a0b18adbd1eb5"
    sha256                               big_sur:        "b7799b3741c9c0c8e5a4c53faad4395af82cdfadf90c41ea43f2952c2c8d6696"
    sha256                               catalina:       "e7095d3fe975262ae4df17cab4ffd687aa3d55070b2d5158f9131330c5f85801"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a13c05685afa0b966e1c8b9f991f22a083420604bec7a28898a36a5effa1b566"
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
      %w[lmdb @msgpackr-extract/msgpackr-extract].each do |mod|
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
