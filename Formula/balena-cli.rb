require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.32.1.tgz"
  sha256 "0d6e68f037cc4ca7243226995f5b96bea4d13c9ec68e83d9390ae8c7fa995ccd"

  bottle do
    sha256 "46f37229f5fa462dcb8e744365248ec9f725aa13bb8b1963616d86f7aa3ed57d" => :catalina
    sha256 "29a9f24689dba92552e1e7747912cd8a1bbca0fb919fcc4a5b3695f5efe37153" => :mojave
    sha256 "5c965891db8a7466903c3edb195fbad3e911923fd67908cb15c55549b9da0a9b" => :high_sierra
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
