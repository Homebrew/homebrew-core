require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-12.1.3.tgz"
  sha256 "5df10f6948bc88ac04bc82e80cac7603b3594234505586d373ccd27d453563b1"

  bottle do
    sha256 "3c8a3af29f490851903f90d46feea27c2a8a824a207e61469326669e8e06c7bb" => :catalina
    sha256 "8f026b3e556372f05662e9d9fefba3f7a10b71b952e1a4e14acf425465496912" => :mojave
    sha256 "9cf37ca3be80c884d65d5bd110f71ea4b90204b846861fb14aeda6163914d169" => :high_sierra
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
