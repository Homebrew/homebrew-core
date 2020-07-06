require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # balena-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-12.5.0.tgz"
  sha256 "dc22fea3c0c78cb6d48d3ab06ac0c54228ef68f7d6b0ef299dc2d58178105ddc"
  license "Apache-2.0"

  bottle do
    sha256 "0af85f0035318f5cbc461354bf1a44318c15e4639bc9194a0eb1ab2cfdd71290" => :catalina
    sha256 "2f3fcd48f888eac4b5fd89deb1df56160a91bbf6795963250a3e2631811318f5" => :mojave
    sha256 "7b04be954e821a2956d826bb35cdd029fc59d0b66f0d8b06a75e8adb43ca3e98" => :high_sierra
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
