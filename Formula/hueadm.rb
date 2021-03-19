require "language/node"

class Hueadm < Formula
  desc "Command-line management interface to phillips hue"
  homepage "https://github.com/bahamas10/hueadm"
  url "https://registry.npmjs.org/hueadm/-/hueadm-1.2.0.tgz"
  sha256 "8b5936a84f112ce1d1ca9a2a917223755413e3dfa3854088fb4f2c01e2470e72"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "ECONNREFUSED", shell_output("#{bin}/hueadm -U test -H 127.0.0.1 rules 2>&1", 1)
  end
end
