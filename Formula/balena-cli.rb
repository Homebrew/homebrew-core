require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.30.6.tgz"
  sha256 "056d229ef4559991f4e9307bbda09870d64bc90896cc33f7459251e5faf0f26b"

  bottle do
    sha256 "929de59a8d93a2680e297876fab5ccbaddff6091d04fcb5da79409fcb3ca8422" => :catalina
    sha256 "b7f3ac76376b80d9e8837c8dd45d5c3416bbf3e013a4d53875d4293c31d39395" => :mojave
    sha256 "257bc9eab64d6cd2aa658cc506debd0de0b7b8265c53d4341b1a6d6435d009b4" => :high_sierra
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
