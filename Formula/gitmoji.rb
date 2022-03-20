require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-4.10.0.tgz"
  sha256 "50a7074c9b89ebfe9428961c752fa1b46bdee9a06bbf637340ca4c014248afad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c71e1b330bcdb745c81b2d8c9d84c50aa16a52d54e624bf8488fddc6a73c393"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c71e1b330bcdb745c81b2d8c9d84c50aa16a52d54e624bf8488fddc6a73c393"
    sha256 cellar: :any_skip_relocation, monterey:       "99af84a803f3d1598edda02e7a71574390081609a2b7e428fb7ebe07e17a2c41"
    sha256 cellar: :any_skip_relocation, big_sur:        "99af84a803f3d1598edda02e7a71574390081609a2b7e428fb7ebe07e17a2c41"
    sha256 cellar: :any_skip_relocation, catalina:       "99af84a803f3d1598edda02e7a71574390081609a2b7e428fb7ebe07e17a2c41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "962670a0969a922c320c958ddea3c2eb4ab7893d6ba93661291dd92b1a59b64a"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    term_size_vendor_dir = libexec/"lib/node_modules/gitmoji-cli/node_modules/term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries
    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir
    end
  end

  test do
    assert_match ":bug:", shell_output("#{bin}/gitmoji --search bug")
  end
end
