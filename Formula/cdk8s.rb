require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.0.tgz"
  sha256 "9b44c1160fa6a8d133d58ca196ed9859ea27c96b8ae329c115f5f1941c108595"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b4b15a0f93b36a7a2727a3d805548cc7817278204ed1e9beee82f037b232cb89"
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
