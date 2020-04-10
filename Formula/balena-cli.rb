require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.30.17.tgz"
  sha256 "982ae07ff72c6882a01943f3514be7dfb3ea55f4261f9aeae8468d14b5c4f1db"

  bottle do
    sha256 "5564c3fabf745d4d74c53792b25dee76c2a53cd218b2123a8f211207328ad4aa" => :catalina
    sha256 "c09b47f3f77a1c8cbfa7d4f187602de7ae8f0c433e3848088bb08efacea6eaa7" => :mojave
    sha256 "fb5563ed9579d8cb63962f6c15d5372b5e71d3f5e0800e908924666680bf85cd" => :high_sierra
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
