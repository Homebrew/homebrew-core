require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.91.tgz"
  sha256 "a4d75be0b50d5d2e89cebd4cf814338535b3690caa0c8e7a1547313cdb1d72bc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8db5a2ac0d86290b75a2a5c7c277cbbc63f75667aff5074a3857ec8b43cd8745"
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
