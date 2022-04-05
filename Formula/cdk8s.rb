require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.143.tgz"
  sha256 "22e38d05bbbd9f0d13f74b3d2cb2bdf58f9460d0d4e46247c6eae796b666c9fb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f6c62a1710b9d4bb3b38e8a4175c39a217eda785f47c357b26ad28d8bbad4e61"
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
