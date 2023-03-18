require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.161.tgz"
  sha256 "392d71817b9b5bc9fcc50a4e8b65a4d8eb685c465ad4617c6c77447438136c5e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1c16c286a083d412c2297a6f5d6e6bcbe7a435c6c668a80965733846034bb5b2"
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
