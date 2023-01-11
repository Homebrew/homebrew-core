require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.102.tgz"
  sha256 "0b085539b2cd6541f9006fd26df222b4d598fd8a18ff9813bc485dde3ae77253"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d8129924250cb97e7ec1c554134915e2b2d3a83e3a5ad49fb3a7ebce61eaac96"
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
