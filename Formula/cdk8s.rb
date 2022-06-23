require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.29.tgz"
  sha256 "db4c5e21c292c925d320a6033de61dd07a8314840fd95721a253016617c31ec5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c479e0cf8c90a839bbba052d1304283df0f85a83e23e3c276219da588490d4c5"
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
