require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-4.6.0.tgz"
  sha256 "b20dd736e3e72d04678da4a186b32edc5f8e94723c6e3fe371395daf74710f88"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95eccbbf2e97aca5960bafe7b4277ae0eb2474b4ff84989d93b95b762fda6d41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95eccbbf2e97aca5960bafe7b4277ae0eb2474b4ff84989d93b95b762fda6d41"
    sha256 cellar: :any_skip_relocation, monterey:       "676f5bdcd51ffda6746009b0d16fb45c02010a2c3fbf43cf8065db65aef8885f"
    sha256 cellar: :any_skip_relocation, big_sur:        "676f5bdcd51ffda6746009b0d16fb45c02010a2c3fbf43cf8065db65aef8885f"
    sha256 cellar: :any_skip_relocation, catalina:       "676f5bdcd51ffda6746009b0d16fb45c02010a2c3fbf43cf8065db65aef8885f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3454273812a3d35f432f37981bc4840a0031507aa2e90b9c2cd42ed38b06988"
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
