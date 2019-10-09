require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.14.2.tgz"
  sha256 "0b694a9ef5b05129940fd11428b9bee13738af5376298a78e6c7f13db5c878b1"

  bottle do
    sha256 "958c3c62bc9b7dd41daaf9428a620b6feef0457b0b0e9f2629f2f8dfad5b6c79" => :catalina
    sha256 "0140b3c368061f2c5b93a9d64f52a93296d2d1a5a57c1f72384188396cf9dc98" => :mojave
    sha256 "1051ba0306ee61adea6912eb84f40fb3a7a84834e4c59708951f302e2acd8a2e" => :high_sierra
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
