require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-4.16.0.tgz"
  sha256 "bc9136aa3433796227d1e4d0b61d37690ff360c386ed4de36ee051e561b2433e"
  license "MIT"

  bottle do
    sha256                               arm64_monterey: "dae77ab968764511ca40234fcb0a9b0684353fb3913a9cf212315be053ee237b"
    sha256                               arm64_big_sur:  "125f047e62ae2ee5df1145ea29ed65c87ac66100d906d2245583781abb5bcb98"
    sha256                               monterey:       "d05d8410fce7adc1dd3b015b8a562e0757e98315a98928f454c1b5ae49dd5905"
    sha256                               big_sur:        "dad4c8eb0f617e16910a5f6c7168435847f052ce6dc3752a39072980642a43c4"
    sha256                               catalina:       "e73c849347f2509fcf012109df611b9410bf02e183be224af38cd2b9682591bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c8b687b1d1f9d6422a876ca200eba5070314970ac492950cb04fe94d531e05e"
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
