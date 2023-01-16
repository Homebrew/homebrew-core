require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.107.tgz"
  sha256 "5284b894f3bade9ad59356d80fa4f5427c479a3319617df8ae5fcf06e8ece2a9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "714c1b1aa3445defb2c024a0c3781993e0105538121b1052b55bac5e251486ca"
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
