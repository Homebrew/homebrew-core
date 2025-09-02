class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.13.tgz"
  sha256 "a500e7fe05822dfcd2946f7432d3cd6ddcbd45dd4c4ce2c166ca5b56c1dee6cf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "328ccab24f177837427e27e95304f1a0cd293e5e48f6720991e69be1f3a1de3c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
