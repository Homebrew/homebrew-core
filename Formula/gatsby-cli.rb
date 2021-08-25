require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-3.12.0.tgz"
  sha256 "6bc2a52847bc24054780ddf8035b42fdf23544884fc9b0e54e351109d0d81cb4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c5be9ad2cd5dfc253b7574ee765d5c4e546da1dcec9066161c8eb1fd1ca45da4"
    sha256 cellar: :any_skip_relocation, big_sur:       "73c3ec8aee12aa372e2cd7eb039cfcb27c297c03d2843e32c84ce9156912ff14"
    sha256 cellar: :any_skip_relocation, catalina:      "a526cb71e4b058f5e71f31bb67314a0b30e068a1de5d46c8a9d99d01217470ca"
    sha256 cellar: :any_skip_relocation, mojave:        "73c3ec8aee12aa372e2cd7eb039cfcb27c297c03d2843e32c84ce9156912ff14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92b742ead2cb4edcc53624353f3f42c88545413e3bc639fc9bb4d19adeef86f3"
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

    # Avoid references to Homebrew shims
    rm_f libexec/"lib/node_modules/gatsby-cli/node_modules/websocket/builderror.log"

    term_size_vendor_dir = libexec/"lib/node_modules/#{name}/node_modules/term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries
    on_macos do
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir
    end

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/#{name}/node_modules/clipboardy/fallbacks"
    clipboardy_fallbacks_dir.rmtree # remove pre-built binaries
    on_linux do
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
