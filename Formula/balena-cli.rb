require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # balena-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-12.16.0.tgz"
  sha256 "87a8997cfa386507d2498ad9a18400a480a15ffd500081c961425c8301250ebb"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "378c73501c8870cfc064c075a2d26187c74a76733760022fa7346a6a390437e6" => :catalina
    sha256 "539091abfadac8c86a96f87e7f1313a83d98dddaef296ef032b840be8b480902" => :mojave
    sha256 "0b9051575db6e4f4216e44491463ab8f0ec5a10141a837d4e4000856f7f13e74" => :high_sierra
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
