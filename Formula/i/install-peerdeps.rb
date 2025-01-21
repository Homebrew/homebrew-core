class InstallPeerdeps < Formula
  desc "CLI to automatically install peerDeps"
  homepage "https://github.com/nathanhleung/install-peerdeps"
  url "https://registry.npmjs.org/install-peerdeps/-/install-peerdeps-3.0.3.tgz"
  sha256 "a1f0e865f9db356aa15ccc9cb56e200c442229bef9e1e1ef8c73bcd587dfc506"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "8b8235bb0d694175e47f0dd39cb14fdc1cf9474c25516f37b7f01a216db0d022"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"install-peerdeps", "eslint-config-airbnb@19.0.4"
    assert_predicate testpath/"node_modules"/"eslint", :exist? # eslint is a peerdep
  end
end
