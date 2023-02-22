require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.139.tgz"
  sha256 "b493afbadb7cabe7112e567cee99f41292e64bf696ad01aed09ce57f30dfcc53"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "83257da64ec11d61882198bb61102c695b22879645f684f893ee7db4b83576f0"
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
