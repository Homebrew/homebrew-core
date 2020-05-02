require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.32.11.tgz"
  sha256 "980984b32183125510ba3c252f0dcc04ea3bb9bc3884e504a016efcc7e86266a"

  bottle do
    sha256 "1e07223296d57f9e28a7c36ce6bbb045f5146ceaf77a00c7560b411781181053" => :catalina
    sha256 "41fcc2a096f97012e3cdefa46f89c1ffeae5fe11b773323d05c70ea352342a6e" => :mojave
    sha256 "dab7636f8fdd6d21f1448ccc0335aadac755b54b840701e0aade11d2ab204361" => :high_sierra
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
