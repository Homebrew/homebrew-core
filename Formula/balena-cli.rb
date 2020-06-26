require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-12.1.13.tgz"
  sha256 "71db8f618414795f867bf7590646dca4a544d1f0ae60afb636153c054672827b"

  bottle do
    sha256 "3e6faaef95ae16a1947a4d1c65ec90ddeb72e07de2e7d4d773e70415b4927d3c" => :catalina
    sha256 "dda75f127dab5ae4063aa439f6af617484ad4e58dcbebf636293f21d05798bb7" => :mojave
    sha256 "b0aeb60363ad7d8fc9efe7311b9587df20d41810b03843ea2a45c4884d7b19c8" => :high_sierra
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
