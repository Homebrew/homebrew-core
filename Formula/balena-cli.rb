require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.14.1.tgz"
  sha256 "18b3294d880cb45be6fd80b65b9416bb9ad23cb3bfa1b085479edc4a251c3ac8"

  bottle do
    sha256 "c95bf3706318a7ddb4c2f88f6c6649b65841c41b3186cd5c7f9ab95c6b54d9c6" => :catalina
    sha256 "fdbffa5cf0ee1ca4db18935815efb6df49d2c721c20755fd136c4c39bcd4048a" => :mojave
    sha256 "a4803dc2c3cd70f785499439463afdeaa7fc13175142659dd2d658f00fa02368" => :high_sierra
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
