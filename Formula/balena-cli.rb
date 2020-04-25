require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.31.21.tgz"
  sha256 "3919b9f8559c6368242184268bf2b95e58e4bf2b42699095dcdc930160de880e"

  bottle do
    sha256 "bb0ad42a873ef429ecb5b86f15883432e0285f12d3a91bfcc16c4aab4e040e72" => :catalina
    sha256 "b45cbc4409268db0cad592a482f5d098bd2c27ddcbcd2fab15947d414977420e" => :mojave
    sha256 "869671f6d5870d8ca82c12185857a884564d61046645d4f7d07a47dda617bd4a" => :high_sierra
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
