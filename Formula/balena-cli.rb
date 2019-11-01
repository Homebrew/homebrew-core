require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.17.1.tgz"
  sha256 "ade718ff3b7fdd0f61497ac7473115901953a2386957832e7f6590e94943dda6"

  bottle do
    sha256 "ba4b02f4e867f348b9bfb3ef58d0ab5a87ab7de1b71aa29cc7d04de31360a399" => :catalina
    sha256 "3cfe94b9b6b2c5525b713ec4eb117b99761ab38a7e481e2017573526171eb790" => :mojave
    sha256 "fd8eb92409fe2ee4167164dbe3d199511f42fbb3035208b68bd4284a91e15013" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
    assert_match "Logging in to balena-cloud.com", output
  end
end
