require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.5.tgz"
  sha256 "17472a3aef6e91f35d5c78996315ea1c77c45c3100d5990a2e9408f815719508"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e1d33c28ecfb1604196c44bcb6d2cb58462890f84e09ad4d3354ba647165979a"
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
