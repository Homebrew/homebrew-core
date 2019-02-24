require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-9.12.6.tgz"
  sha256 "1d69484035e848c10f99c24b2353654d65dcd67c5f4ff949b08c99ce2aff267c"

  bottle do
    sha256 "79445b13bc6acfae8befab94d7051856f5819a340f0e0380cc3e2cf493953c32" => :mojave
    sha256 "25aa1754c7bd5360d8d071ca17e063a560d6d8280403920718f866618c52ca3b" => :high_sierra
    sha256 "f15e3681c8db2bbdd96508182e3b3dae0feb87c8c20f56bb1ea38ec37c0a9092" => :sierra
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
