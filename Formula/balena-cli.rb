require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # balena-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-12.12.0.tgz"
  sha256 "91cc56907d6c77295e1e4628e52fa272d46a9cfdd8b8db364edbdb8840128c80"
  license "Apache-2.0"

  bottle do
    sha256 "988699fb14a192cd4c4a34f57323a72ab74e5fbb2eb89e8aacf6b8cbfe5cfd53" => :catalina
    sha256 "0c3ba3d0ae7ff4440d0653638b24e8a7c536ff9c8b5f7ed2da51a9722b0fefb6" => :mojave
    sha256 "ea4ded2cbba1e571ffab3a365a676f8cb47addad1a44d81953cc45a48c447150" => :high_sierra
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
