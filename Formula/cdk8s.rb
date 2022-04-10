require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.144.tgz"
  sha256 "aa37d976a2fbbba797947f050de413f978948d44d7f043be98dc971795d94258"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d86d5576861afa5d5b702277814ee9a01f8cad546838bd5c2d66e26b6ad4d224"
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
