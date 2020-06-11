require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.35.20.tgz"
  sha256 "d311f758ac0d566415144ea50182fee8b34061a49b0ec955a8c39026450d4cf9"

  bottle do
    sha256 "18807fc5dce8140e7e0eaaa075cc66fcbcb7c0d240718ed11e27757af769b158" => :catalina
    sha256 "05f361af1cb03a2233d323c2c127fbc275e8628c99770d69538f56eda062a6cd" => :mojave
    sha256 "17d8ce2ad3115b5d641d6b927e75c16095511d2e254f225a34ef437072fc9dae" => :high_sierra
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
