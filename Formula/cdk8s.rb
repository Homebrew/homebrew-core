require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.39.tgz"
  sha256 "2c4c4c8fd6cb61911362b651e2c713142474dc4de2ae09831f701a7b93d44d6f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "722a10a08356f678c72fa80c6573b234562485cfdbab133b3d228859a5cccd0b"
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
