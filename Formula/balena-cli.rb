require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.17.1.tgz"
  sha256 "ade718ff3b7fdd0f61497ac7473115901953a2386957832e7f6590e94943dda6"

  bottle do
    sha256 "adb04f33ff3f86c235cbce8a5c600e860430ccd0b260709c3f9683800ebc00c2" => :catalina
    sha256 "d1f5b35fd5c3dad6b2b370ddc9d7ddcbb9ca6cae869b1b2454729c20a397530c" => :mojave
    sha256 "5500f5a7ae08ccce98fcdd72ab2c70dfb642eaa509f916da89a1376392f05a28" => :high_sierra
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
