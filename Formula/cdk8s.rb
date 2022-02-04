require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.90.tgz"
  sha256 "fb26ddeafa1aa48ca9fa07cefd127e80f6276cd781219918197f22edb9f167fe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f5f7687012198e84d56ea1983f5bbf8e43ef1eb41ae1af24e59af367f6e7275b"
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
