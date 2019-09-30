require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.13.1.tgz"
  sha256 "3536ea239da6ebc380eb341be88f4959e625ab8a965076432efc88c2a7cd9bcf"

  bottle do
    sha256 "33742459816ea6b1e37925c3f00e0a3d8f57e32ef52a9ef48fa209170becc071" => :mojave
    sha256 "75edb04fd8ec895439e527e08b452a37ecbc548b54eb5292cc52ff3aa92458b0" => :high_sierra
    sha256 "506e648ebd34203c60e3dc319548a51b701d8d954e15da6494fa57f42079ca0b" => :sierra
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
