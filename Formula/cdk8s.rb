require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.118.tgz"
  sha256 "1042146c445b06f3c35752053277500362cb0b4284982dc73e6caaae3b4fbd80"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9847605ad99ad19b83eb192325726aec19a29c078fbc16b13b3ea86fe500508a"
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
