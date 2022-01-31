require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-4.6.0.tgz"
  sha256 "b20dd736e3e72d04678da4a186b32edc5f8e94723c6e3fe371395daf74710f88"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59400326e3da2d2cd38b4349d8949f5200718b2dc9bd19979c161c80b3109de6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59400326e3da2d2cd38b4349d8949f5200718b2dc9bd19979c161c80b3109de6"
    sha256 cellar: :any_skip_relocation, monterey:       "a7dc74d44f693ef47de4511516cc6241ae842fd10f8e61eb9c22634f0e86bc3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7dc74d44f693ef47de4511516cc6241ae842fd10f8e61eb9c22634f0e86bc3c"
    sha256 cellar: :any_skip_relocation, catalina:       "a7dc74d44f693ef47de4511516cc6241ae842fd10f8e61eb9c22634f0e86bc3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a24baea2be0ecd70ba507496d2feebb83ffa3757aabcb28ff39982fda8f1f8f"
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
