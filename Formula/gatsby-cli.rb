require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-4.2.0.tgz"
  sha256 "4165d8be8e620e9919e937eb384eb56078f246473dfc0b4da4749e3a20f9841f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ab378d6b2fc1cfacfa28877205766764ec954451fc796fcfd3271bfdc4d1a20"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ab378d6b2fc1cfacfa28877205766764ec954451fc796fcfd3271bfdc4d1a20"
    sha256 cellar: :any_skip_relocation, monterey:       "03316ea94fff5ccc8b203df1fbfc6801273046658cf45066f2eacfdfc13cf01f"
    sha256 cellar: :any_skip_relocation, big_sur:        "03316ea94fff5ccc8b203df1fbfc6801273046658cf45066f2eacfdfc13cf01f"
    sha256 cellar: :any_skip_relocation, catalina:       "03316ea94fff5ccc8b203df1fbfc6801273046658cf45066f2eacfdfc13cf01f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d62587f4c00088be9bc0284b2d47348303fb2b3e730077446a9cdbdf55db714"
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
