require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-12.1.4.tgz"
  sha256 "7a400ee135fec68e2c389847d9c63f31a0fc0262c04647327cc556d6425f95c6"

  bottle do
    sha256 "ddc0fec525c2fc72998aa5f9253da995b4de46f5311020f77b7b0d3f056f94d7" => :catalina
    sha256 "d75a041041dbb3493135f04b9db1de842b92a4c15f21e2a7a75745f4fa9fd941" => :mojave
    sha256 "706be32557e9a20f1cb3deb5d48861c5d36b0791c97caca8a97421e66dd7ea9b" => :high_sierra
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
