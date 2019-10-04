require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.14.1.tgz"
  sha256 "18b3294d880cb45be6fd80b65b9416bb9ad23cb3bfa1b085479edc4a251c3ac8"

  bottle do
    sha256 "9fbc256ea53ec69b13af36b3c69b35fd1665933bc31ef9fad8b9d01e23866c70" => :catalina
    sha256 "645121ce6f7be2a90963e1db7082519e4b38c65b43c45619aad28e47c9ec6bd8" => :mojave
    sha256 "22e0e4bde2fcb69a2284a0fe02bbb24c10695e9514452d6de6606e4053e4119d" => :high_sierra
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
