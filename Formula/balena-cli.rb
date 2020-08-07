require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # balena-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-12.14.0.tgz"
  sha256 "c44712d99b9a227980a90523b0cdd256b78c240e524730b81fd6738032ec990d"
  license "Apache-2.0"

  bottle do
    sha256 "2475e4f308feccc35fc2596c0ff9fc2c215ff8b63de5cff6be9b0a37c2dc6f5c" => :catalina
    sha256 "38bd5a398661ed223176160bf86d46e3f32cc47843dc43a955f5cb8f8e566017" => :mojave
    sha256 "caac09808a877df6067c5e17f63b824865f8f8bee171a8c9420cc87bfc196411" => :high_sierra
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
