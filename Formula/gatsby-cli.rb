require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-4.5.0.tgz"
  sha256 "8c528ccb4f2e7ef24ef53cc65c9e36ef057d63aa85801fe5cb2204f5e97c7f80"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d88bc937ef5c3e7fb80a6643a643083d02f604d183e6ac6b9f4af1b4dc2e4411"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d88bc937ef5c3e7fb80a6643a643083d02f604d183e6ac6b9f4af1b4dc2e4411"
    sha256 cellar: :any_skip_relocation, monterey:       "c684b5ab291185a5e44dd76ea81391a07c801dedeaedf46e38502000c5afac33"
    sha256 cellar: :any_skip_relocation, big_sur:        "c684b5ab291185a5e44dd76ea81391a07c801dedeaedf46e38502000c5afac33"
    sha256 cellar: :any_skip_relocation, catalina:       "c684b5ab291185a5e44dd76ea81391a07c801dedeaedf46e38502000c5afac33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf9a2bf9a309b340992bd4ac5a46f7912c9a3be8f318aaead34424818d5a4150"
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
    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir
    end

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/#{name}/node_modules/clipboardy/fallbacks"
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
