require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-3.18.5.tgz"
  sha256 "412162508b1e44f8f1acb6a89b5ba621deabe009e6cf6056129c11438e376ce0"

  bottle do
    cellar :any_skip_relocation
    sha256 "7527f77bdd1566bb112656728d1b7d4de93aef909c132739c30f50ea9507b15b" => :catalina
    sha256 "677b8c0b1b20763c6efbff470f7284b72cf9c0f093848f970aa00f966994a681" => :mojave
    sha256 "2b365382da4abade3e1b157107b0bf8fab19d8cee6501c5ef312802a864ca070" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
