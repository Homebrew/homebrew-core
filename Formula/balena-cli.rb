require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # balena-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-12.10.0.tgz"
  sha256 "87c35b105d2f158862c1b891d49375296062db685db6a64ca2a039c942480553"
  license "Apache-2.0"

  bottle do
    sha256 "a53852605dad9e673aa53cb2d8cec741fbb97a0cd109454ceb95a95cf2046991" => :catalina
    sha256 "966ed6d3d0ff76c200309714b2efe7b20cf3a556766c30a1c90f0e6b34451172" => :mojave
    sha256 "ea44244e6ecb7d7f2dfa32c3466ca99808c20b6b67a5352547a1806a7eb8bee9" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end
