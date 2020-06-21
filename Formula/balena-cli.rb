require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-12.1.2.tgz"
  sha256 "e02704edb0b1ba20179365ba0775e3632c4cee896da146c993f663014f5b3a8c"

  bottle do
    sha256 "ceda1719d6dcc4018036c3f613ade058603143e8c19e5374993f1fe490be78f2" => :catalina
    sha256 "e938c3b5325d1f3d5a9d37de79476aedbb2327288b34cc58560f4f07c1e3c4e0" => :mojave
    sha256 "87ca24d945c7e5306f01fae85a8ad2bbbdac2b26264377db6418e694f5e6d36f" => :high_sierra
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
