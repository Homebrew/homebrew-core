require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-4.7.0.tgz"
  sha256 "46f6c9bf0fd0ed0d9160616dd2a625b63017009cfdd4d245603c0696dfbf0b25"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc86dd2013ec61540df07b3f50bd60e03088c6f153ed6ba60534c1c0b648dd3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc86dd2013ec61540df07b3f50bd60e03088c6f153ed6ba60534c1c0b648dd3d"
    sha256 cellar: :any_skip_relocation, monterey:       "ae6296db8f16d8933fc9a9449d4dde9f045fff962708bae1bfbb9dd23073a147"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae6296db8f16d8933fc9a9449d4dde9f045fff962708bae1bfbb9dd23073a147"
    sha256 cellar: :any_skip_relocation, catalina:       "ae6296db8f16d8933fc9a9449d4dde9f045fff962708bae1bfbb9dd23073a147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27da0544c6cba9ddec2d28d158989a9f47090dc68683232bf5e115c6e4d65c1f"
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
