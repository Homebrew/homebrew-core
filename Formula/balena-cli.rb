require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-12.1.4.tgz"
  sha256 "7a400ee135fec68e2c389847d9c63f31a0fc0262c04647327cc556d6425f95c6"

  bottle do
    sha256 "8551ee926336c819c4f1c8f06d0b77feccede5989c8153e2ff4b86e8ee691892" => :catalina
    sha256 "120c0d5609edec03078a064f070531abe9540042d095e300b5ea57dc5814e0b5" => :mojave
    sha256 "ead24c89921bd20f8dc946731fbc7a068d0426a3cb134e480e1a0f5d308516c6" => :high_sierra
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
