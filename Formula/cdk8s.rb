require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.31.tgz"
  sha256 "b1bcb1c148b9c3dde67960d5be36ce515168342529804c16c6470c58cfd3a388"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9953e11088c8ba4f8a57ff391f5ba35252bb19d1d5bd68a30ff6e618c15698ac"
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
