require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-3.11.0.tgz"
  sha256 "518af14ef95874e0dfd8c5cfeb54fe3901db98174fdc954885e16dccfaf3aadb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9839eab73887b164bffc495ebf08266ee627f820a9f90f9e3044a08551e49e96"
    sha256 cellar: :any_skip_relocation, big_sur:       "664884e7472b88c135790fe6448fff49fa31d68ed3b1d9f9fc591f877d78a0e7"
    sha256 cellar: :any_skip_relocation, catalina:      "664884e7472b88c135790fe6448fff49fa31d68ed3b1d9f9fc591f877d78a0e7"
    sha256 cellar: :any_skip_relocation, mojave:        "664884e7472b88c135790fe6448fff49fa31d68ed3b1d9f9fc591f877d78a0e7"
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
