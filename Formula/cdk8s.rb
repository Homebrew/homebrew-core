require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.147.tgz"
  sha256 "c74e8c0ec63fe89a0222cc85cfc7683eac1ce71fc59870408f96195e13706d31"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3c76547654a7524ce1d3483f0f805813e83a0dce17368c781fe0459a4b314436"
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
