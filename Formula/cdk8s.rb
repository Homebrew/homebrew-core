require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.153.tgz"
  sha256 "4a7bd9b58ad4b750a3031d2549fe1a1b924bc457d21ec636b059c60f933ec338"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4b7a44a34e8b2a6a98b8750dd02e3bc02e2d99eef5051f464c95fee1a8d50663"
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
