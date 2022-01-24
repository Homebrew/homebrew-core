require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.83.tgz"
  sha256 "92a34cbff6ade24812f2f8bbec13f7184cc5a299db6d09295e7e6d9b85cbf430"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2c920e9b82e6bc0571ce68fb0b15a8a763102dd7d57f7df08d709af0fd1d1642"
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
