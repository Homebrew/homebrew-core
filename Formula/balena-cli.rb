require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.7.4.tgz"
  sha256 "c60b298d110ff8d440d98415f5bb7d5e1d66fc119f99fff1a3131ffc5ed94a74"

  bottle do
    sha256 "1e92e86c3814ffa8544c37fb5c59804644c88b1559c30b51c206ea2a854f27fa" => :mojave
    sha256 "b6068716ce3d8b6e8861ed546c13ac642c5dd64b52afb789fbae462f905d996d" => :high_sierra
    sha256 "02da8a3fca0960f1867966be5cebf2211979bbd2bbfee748bd766cb20b2c2c57" => :sierra
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
