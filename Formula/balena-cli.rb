require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # balena-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-12.15.0.tgz"
  sha256 "f8587ddbb030c17a469c73d546f6048040192dbcd7697fae10a8ac2f78871e76"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "3ee444506429ea6d7af6d2576cabc3f04506e95642aa1afcedc0cf6215f5c03c" => :catalina
    sha256 "d7683f0153606bd5de47637078bae8f85442638d16764f99fbf390bdec8e5366" => :mojave
    sha256 "520ddd6a83c15702ee18949983c34eea6370c7992ecfc4adf70c4a30f80fef18" => :high_sierra
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
