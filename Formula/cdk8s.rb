require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.121.tgz"
  sha256 "d8eac263bd825f112ccbb2d341323dc426198d68a08fee96b372423c0dd46a16"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1874f27ad8e2cc4897ca6c1a9b47691557126aab7313fe753a28bbcd7342fa0b"
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
