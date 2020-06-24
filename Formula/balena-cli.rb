require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-12.1.9.tgz"
  sha256 "8acd83f362660c654c9e6dd5a79377b7877109d194bd2c23bcb962fce8dc59cb"

  bottle do
    sha256 "307032742d47659bc37298126797dd6cf18ebe257335d34228329d6a40bc8980" => :catalina
    sha256 "bd20b20d07e72e77951de80db499edcaa59240884ea19e0adc2136aa486e2b8f" => :mojave
    sha256 "891cf3f180f16cdf75e1067c39e7fc081edcbafb5a5a26ed4c9c58aa5dcee025" => :high_sierra
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
