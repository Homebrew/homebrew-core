require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.142.tgz"
  sha256 "7f894b4c438ff9d319df2ddb7978de4bc5bfcff79422ed0c4811f0f764f53f28"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cfa770531034e1963a1bfe898d0278b3bfa90314c7264138c9bfc2f724098f05"
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
