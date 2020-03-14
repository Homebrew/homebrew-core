require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.29.3.tgz"
  sha256 "9fb41ad0de45df26588b696f08f8ec28cc354418d6ae9eadafe85c0e23109aa8"

  bottle do
    sha256 "3e0208fffe65d06120372261677737a7384078e113610f207fa5ac225e7d3bf2" => :catalina
    sha256 "3a78470c2c9b3e56e47e694cbe8088663a2d3749a28b6675ee6bfbcd2c02f37a" => :mojave
    sha256 "46f7c67fcae6d006c9a2e24957d2af16e7b209688d32679ed11129833d1acd82" => :high_sierra
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
