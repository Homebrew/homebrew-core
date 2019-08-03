require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.7.4.tgz"
  sha256 "c60b298d110ff8d440d98415f5bb7d5e1d66fc119f99fff1a3131ffc5ed94a74"

  bottle do
    sha256 "875a13af8c83ed5dfc47fcb994d405192cf0d1a4ad50e991a5100215d4ce40bc" => :mojave
    sha256 "74b85f79d2148099bbcf2884655ba554323638a7fe959eefdc2aaa629298c1fb" => :high_sierra
    sha256 "2c20e6f82fd9ba64d366df3a08ef75c3355db80b528b1872160081d95a00bf6a" => :sierra
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
