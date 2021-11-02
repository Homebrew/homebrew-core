require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.21.tgz"
  sha256 "a71637ab7d97e465d465fb6a9b0fe71f93f236ab03df84a27eaae97aa978dae2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d074e14c3fec3f7c6c61836ef4d993675840fd7550871e07156d1f7edd69ff58"
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
