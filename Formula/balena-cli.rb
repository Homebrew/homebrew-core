require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.6.0.tgz"
  sha256 "f92c90b67170b697762bcdbd11848afd366191772a5e97d9d0c77abe3e0ef474"

  bottle do
    sha256 "f1bc046cc39508cfa18a82fb01ebf8f845207419c129f722ba88f4453cad7386" => :mojave
    sha256 "3dedbb8ee71a2185b22606f270e6c809dbcabbf977259060a09f758de3ca65d2" => :high_sierra
    sha256 "69b24889f616beca611521384bf4252316971b1a5e7264b0fe3c010c3340ed26" => :sierra
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
