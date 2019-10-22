require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.16.6.tgz"
  sha256 "486352da640d98647fafebed9b9ec1094ec75ba917b389268f8982096a4fbfe8"

  bottle do
    sha256 "c34add57bfa45dea78e9a8a6ebfb9026dde8db7cf4111f3c12b0007502d61a07" => :catalina
    sha256 "acb4e886c1c4fadbb4666f4a7cda74b51072b3be66f25d8cc1dafe1a844e0efc" => :mojave
    sha256 "3ec453d9cf7724829efe5f015903813a19dae7bc48dfabe7946257e76a435645" => :high_sierra
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
