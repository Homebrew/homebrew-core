require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.33.2.tgz"
  sha256 "2974217bc0fea594c30cb86f5866bd887a9a39cd94143bb4364cb263c2794235"

  bottle do
    sha256 "8d146ef8d7f831e85f819c2027a8d5a35b813d806097b5f48e70a227e7bb5003" => :catalina
    sha256 "d3b2b332b2f0263dafb57472e7c2a8f6965231a5c5b7ea1337b03f78ae685057" => :mojave
    sha256 "d6ed40c7b1855d9a271e177caf5384328c1587041355d2fbb103e563943884ac" => :high_sierra
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
