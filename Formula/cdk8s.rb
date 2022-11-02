require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.34.tgz"
  sha256 "eddbd15e8c517c7be4d1889f6e3ded362dd02824cb2a1a63d9d537cca9691123"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1e91c0f1a83b689c10cf6dedca2998c9c40f150e2ca5f4205b30b962dc3bc8c2"
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
