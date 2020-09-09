require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # balena-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-12.18.0.tgz"
  sha256 "92080d65d98eb0e1a402a7222d9fe205c3ca321b028f817c8d0331d026fcbe5c"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "4f3058b9dfffd2a5d5ace1b991635d05e9fe756da92b09b35b83866e9878f441" => :catalina
    sha256 "5834bc361e05f0b8c0598b502a2c85fc6115e399da88cc6c70e23d94d13df739" => :mojave
    sha256 "be0e06c0b0098d8260eefe5dbcf1866a9c5c87200e58a74b82c924644912ee33" => :high_sierra
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
