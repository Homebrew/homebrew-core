require "language/node"

class InstallPeerdeps < Formula
  desc "CLI to automatically install peerDeps"
  homepage "https://github.com/nathanhleung/install-peerdeps#readme"
  url "https://registry.npmjs.org/install-peerdeps/-/install-peerdeps-3.0.3.tgz"
  sha256 "a1f0e865f9db356aa15ccc9cb56e200c442229bef9e1e1ef8c73bcd587dfc506"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "081330377388f0833a98926f1e1e734d0556bf374eac0df2423a0404d0739a89"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "install-peerdeps", "eslint-config-airbnb@19.0.4"
    assert_predicate testpath/"node_modules"/"eslint", :exist? # eslint is a peerdep
  end
end
