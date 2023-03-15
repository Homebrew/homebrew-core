require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.160.tgz"
  sha256 "74960bad5f1d810c5d87c92b7e2706e5d35e8b57f421e22f4d203d98f388756a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a646fb4356f4ef5a08f74636df0dba834cd050dd970a6bc8086446fecc9276b8"
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
