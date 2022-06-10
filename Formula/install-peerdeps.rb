require "language/node"

class InstallPeerdeps < Formula
  desc "CLI to automatically install peerDeps"
  homepage "https://github.com/nathanhleung/install-peerdeps#readme"
  url "https://registry.npmjs.org/install-peerdeps/-/install-peerdeps-3.0.3.tgz"
  sha256 "a1f0e865f9db356aa15ccc9cb56e200c442229bef9e1e1ef8c73bcd587dfc506"
  license "MIT"

  livecheck do
    url :stable
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    raise "Test not implemented."
  end
end
