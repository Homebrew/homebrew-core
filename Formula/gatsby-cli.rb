require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-3.10.0.tgz"
  sha256 "91ded5611f62dc948a3903f5d6a541877f8e4fd5f8920989e5742d0dece8fd74"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3e8fb545f5291ba9eca54cb8de735fe0f2a12542645808a395dbb58a8cd668f0"
    sha256 cellar: :any_skip_relocation, big_sur:       "6f252b2e3d0a4793e8ead4e65cb571db0dee8a2156d7c8ed6bddf307648540a6"
    sha256 cellar: :any_skip_relocation, catalina:      "6f252b2e3d0a4793e8ead4e65cb571db0dee8a2156d7c8ed6bddf307648540a6"
    sha256 cellar: :any_skip_relocation, mojave:        "6f252b2e3d0a4793e8ead4e65cb571db0dee8a2156d7c8ed6bddf307648540a6"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Avoid references to Homebrew shims
    rm_f "#{libexec}/lib/node_modules/gatsby-cli/node_modules/websocket/builderror.log"

    term_size_vendor_dir = libexec/"lib/node_modules/#{name}/node_modules/term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries

    on_macos do
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir
    end
  end

  test do
    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
