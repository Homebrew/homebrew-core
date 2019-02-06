require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-9.12.1.tgz"
  sha256 "19244422731ac93f1f8b5a673936f54cfab80b1ee30eb9c7b1d63d6c9e215b7e"

  bottle do
    sha256 "9379790cb913eca38cf205834b823c835a9a9976f00eae4fd658dd93168d1fc2" => :mojave
    sha256 "619649fcfcbb98022f7051536302077de0194c461800b3d3418bd12855d4d63e" => :high_sierra
    sha256 "e948338c99b7b7664b9dedc9128c2cb0e64d6c06327f53bf94783d8ab5245a4e" => :sierra
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
