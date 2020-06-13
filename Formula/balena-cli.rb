require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.36.0.tgz"
  sha256 "6cbbf3e8db2f9abe9c86a259cb6da707b10c09a70b00e3db454320c460bec1ce"

  bottle do
    sha256 "496720b30aa14edc6ae560414d2bc37ce895f210d9033459974753015841c824" => :catalina
    sha256 "b7f576f463ac5baafef6a1c44951335492c08ef8509c6928a0682378ce31444f" => :mojave
    sha256 "ddfec192b87683ee7ec9c9340cd1d39e762afa6011d207db437a852af6a1b7ed" => :high_sierra
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
