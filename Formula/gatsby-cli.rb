require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-4.19.0.tgz"
  sha256 "0a4cf79160d17ff32fbc69207739f4cb24da4e204e04b1281bb66272a1a35676"
  license "MIT"

  bottle do
    sha256                               arm64_monterey: "8754eae2be67eae0f31258bb287b8032ad94d6f430f9d5c846aa838a3837db2a"
    sha256                               arm64_big_sur:  "60b36e57bd000839cabe3844ffe2d6d64e6280cbbb525859ecb671ece3d1a40a"
    sha256                               monterey:       "a01b1b8930af991867de72574b392397e2504fd213cc4a236e8e0876a8dd013c"
    sha256                               big_sur:        "085e554c213dd059412458bb7f7dd04f61abf7f12270899aebfa71ec588a34b2"
    sha256                               catalina:       "370e2c97b25eaf4b250bd82d1bf14178c55d9763af12881e0e05b88d594d0c02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43b5b886e83f5274d4f9188141786ecd862eb720bde81091930f2b9e56d64373"
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
