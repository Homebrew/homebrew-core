require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-12.9.0.tgz"
  sha256 "035ed2549ec4e9fb3fcfdd8f1dffc3eb690430ab6c92225451c9018af77f5cb7"
  license "Apache-2.0"
  throttle_rate 10

  bottle do
    sha256 "45c34601d6f850fe3e66b418ab53a627a31049acca1982cef16b10e2215758cc" => :catalina
    sha256 "5343d12792251fa8ebfb81d90774406416e144cfd7a3a0b975feff7cab068d61" => :mojave
    sha256 "a46aafea91b8add40f0f7624f1a204dd52f5634a5fa58ce24f3c8bde12b4d01e" => :high_sierra
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
