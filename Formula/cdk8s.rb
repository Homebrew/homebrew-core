require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.151.tgz"
  sha256 "4bfb252e68550de452c05d551579c92add19a267caa9e74b6d31c269b9da3057"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "44df5bc928cfac8fbffe5e4e0d80cc28473261fb52a6d44b8490ce3d722aa180"
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
