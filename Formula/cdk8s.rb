require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.133.tgz"
  sha256 "423305e26a4fa10879d5d13b0b9dcd17c17b0031f4c80959d1bedc5279364cd6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c256d1649c6f46b3477692113573e2872335d2a1f666b184965d6adad5ea38da"
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
