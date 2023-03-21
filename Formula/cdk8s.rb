require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.165.tgz"
  sha256 "09797de747b4b8b230e21f3c85bfb64a82d01695d76a4475f023bbd797f8cc5a"
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
