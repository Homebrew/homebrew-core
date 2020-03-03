require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.28.11.tgz"
  sha256 "fdfd92badf5dbd02dd85207edb9239be798b1f2972bf5f04d49357c7ed61199a"

  bottle do
    sha256 "533765eb2b21606d0b4acf44fb72079919b441f80533570eb2cc54e21fbd4411" => :catalina
    sha256 "6d11b646f8c172503870fe5b7728039e73bec46540f7e91cfe3ec45759cfab76" => :mojave
    sha256 "f7c1a0808c3de116bd2ea0e0657508732119aad2bf1a124bc7685939364258b7" => :high_sierra
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
