require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.28.11.tgz"
  sha256 "fdfd92badf5dbd02dd85207edb9239be798b1f2972bf5f04d49357c7ed61199a"

  bottle do
    sha256 "bc78ccd9defce92e19c97dc783bb555aa8af2173b52badb7b943607757cbfcac" => :catalina
    sha256 "081d13140a70eeeeb83aaf9850e69ba7996b52cf712f28304233876ae00fb925" => :mojave
    sha256 "556c9f65f4a2bfd97dc21da6ea31fe28b0ab1ff5b12aed22782ed6266202b241" => :high_sierra
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
