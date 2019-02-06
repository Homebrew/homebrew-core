require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-9.12.1.tgz"
  sha256 "19244422731ac93f1f8b5a673936f54cfab80b1ee30eb9c7b1d63d6c9e215b7e"

  bottle do
    sha256 "1e11dca0cab1b9760c80c23f160477df9fe3b86b75928fd4d4d33d03dabdadf8" => :mojave
    sha256 "b92c9b701edf03e4ea22b525c41c972b1c8f3d8ab077bc9c2b6b22e317e992de" => :high_sierra
    sha256 "71801af30f21f8d4bd6b2e8fb1b4508aca379080a7126a8359bbdfa8b79495a8" => :sierra
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
