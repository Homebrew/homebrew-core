require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.7.2.tgz"
  sha256 "4b293d15d22570990ce93d8023019fa9ccf6798f1c055a8a051ac115a0d2fad6"

  bottle do
    sha256 "8286dde902e1ea10a586f8548692e4478a14c4c5dcf0f2476315360688cb0558" => :mojave
    sha256 "564ec689bcf361833449703f8514efb0e9e9e34f11150106696dc8646d472724" => :high_sierra
    sha256 "f4fb76d77847bf62dfded4678e17557ce0ec5248f9fff8619e01ae167f4a51b1" => :sierra
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
