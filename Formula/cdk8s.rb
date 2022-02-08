require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.93.tgz"
  sha256 "82087bf3272c47344abe89c29dd1972ccbc3fb2c99d938024998a16863642223"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c66d4937cf8bbba08caffc81243f32cd8bff0e1e74e8487754cfef68f0355abe"
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
