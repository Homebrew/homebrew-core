require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-4.0.0.tgz"
  sha256 "ac3b06ef64872627d7c7def34ebb7144bf0f276858d9e2bb5679a409dd3552b7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f91ca8b2209acd4762c214b30844e0879181196f05086efc7d858004f443761"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62c89f11ca4ddd50aa4c7aa62ce74c7eb2e423bce2d37dac1d1d3f8b1cd008fb"
    sha256 cellar: :any_skip_relocation, monterey:       "ecdd1c3187af5767265e27355e90fd0223f81bdd0f392a858288bfaf295e526a"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2a71873bcf8a72ba535d1cd05386c6a2625ec17e3a33318b9e70d45cacefc31"
    sha256 cellar: :any_skip_relocation, catalina:       "e2a71873bcf8a72ba535d1cd05386c6a2625ec17e3a33318b9e70d45cacefc31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a535f47bc423752be121b42e5b6c588e0d9b739bce1c2c3d07da7fa3c457c06b"
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
