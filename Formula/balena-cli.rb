require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.35.1.tgz"
  sha256 "2001b766415312723d0f556f7456b931983376f67ee338123a8623caf50e15f4"

  bottle do
    sha256 "e1776ebb95a9015d6f15a7dd9962b4eab6e1854ce50e7505a71070af88c552d6" => :catalina
    sha256 "d7b8f2667e22d9af9bf6b9389334bead700f0f2e85bc6ddac8d8ef20ecc2c88e" => :mojave
    sha256 "e98dc2e4edba3a4874a4427d3ebeaeaeb4d5e3f65ef587506977f3652f29a71e" => :high_sierra
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
