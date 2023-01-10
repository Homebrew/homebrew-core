require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.101.tgz"
  sha256 "eeb1289bebd5002b003f6cf3252c9624dee4c165f92126bb9ca18919e206c62d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "aeece7dcdc35ed646d22f933863e93bcc1c741a10f8113bc37e0b1155f7b8e4a"
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
