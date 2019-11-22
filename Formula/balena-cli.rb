require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.18.0.tgz"
  sha256 "39890bd18d6649ce041f477c22b8561027bdac70f0de7885d79709b9cb4875e7"

  bottle do
    sha256 "0a5dcaf03c6e45854662631da360f55ca55b16f34341ac4ea1e024f2e0a79f19" => :catalina
    sha256 "fb3b0cf10b340752cce688946d79f55fca08b842a27d3e0c5172b1706724c89b" => :mojave
    sha256 "bfac0f117924bf61f81b8d212c8731bc144b429a5bfa97674a4044b6bb6d02bb" => :high_sierra
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
