require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # balena-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-12.5.0.tgz"
  sha256 "dc22fea3c0c78cb6d48d3ab06ac0c54228ef68f7d6b0ef299dc2d58178105ddc"

  bottle do
    sha256 "a26a52cad4bdd470d86bf2a01e7dba0087da8d9b1859fafa05dfffa370cd10d3" => :catalina
    sha256 "804adb47ccb36f3b3cb1f9fbce3013ba063aa5f6c134822fbbd326bc46918820" => :mojave
    sha256 "460f6dae87729bc2b12a9e12fc69c7696de41159b23d679a247bb0957337305d" => :high_sierra
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
