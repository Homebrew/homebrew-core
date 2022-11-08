require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.40.tgz"
  sha256 "00005aa057f5884e37395099942d1be4fa58d774c66fe80363d8f40781ce1e22"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6759fdd01d9070bc18b592d1499fc301e12b667f01dc962f11d2ceefab53b6f5"
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
