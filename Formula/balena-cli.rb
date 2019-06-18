require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.3.1.tgz"
  sha256 "193c5b66193ffee3b9f4b047201f67c033f7c31eb9bff45b3c3a59a901043ebb"

  bottle do
    sha256 "d8a943e35c4075f279e6b3468e6c25aba1a4d63bfa9d601a51c41f3f84fa62e1" => :mojave
    sha256 "8e8c8019e4c8618a487ccccaf7a0e0ac086c7d6b0691ffe19e7180153950f6c7" => :high_sierra
    sha256 "e164a41d50c9061a5b9b6983c25e3265b55bdb28336af4c80cf3196d79954760" => :sierra
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
