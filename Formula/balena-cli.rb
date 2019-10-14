require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.14.3.tgz"
  sha256 "c88bac97c87340ed3640cca41f26873d2eae41f74f549120ae4698a1c74922fc"

  bottle do
    sha256 "e2f9bebda924bb0c591b71292502c9f86f1d9c92dacfdb0fe07ba373042fda98" => :catalina
    sha256 "efd6d0fcfd1f7fd70bfc7f0e4730d9cb0c2b8c063b1b175d45f930cd14a65bde" => :mojave
    sha256 "613b3ea5bda5d33f1e3e1613dda0d3bebe30fd9e2d09660d1c299817d6e39022" => :high_sierra
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
