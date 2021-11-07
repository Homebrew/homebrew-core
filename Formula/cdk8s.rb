require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.24.tgz"
  sha256 "660a03a954e97fcc1dd4b24cacf12efefd6c9047c52d0fa4fb0a441b1cf52f4c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "865bf42312f3debbc8731dddf041035a472b1d2e57042ccf68eedd552bd4cec5"
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
