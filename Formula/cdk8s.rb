require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.24.tgz"
  sha256 "18efd72edc3fe2f7a1bd1fc0a1c7e40c81fbca02f03c9c9901116cde3fe43723"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eae74e259f6855f1234134c39703f1b4cd563bcafcda56607d2b84f2d3b8a45a"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end
