require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.46.tgz"
  sha256 "dc3687b9fcb307cc12f78292010661bbe6559cef4df83070d2cb3363c5a5f8e3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fcd75ea045b634a60524d7b2ee705c70f12113d1a0d5f2437816c944a92ed45d"
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
