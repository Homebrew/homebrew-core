class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.203.3.tgz"
  sha256 "5e809c16f3b1b422b716cc7ad9a3f5b037620bf9cade275fb1e9f188a41ccff0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "88767b42d1b14ed0703c9cd138837a13ddd99583409694f0cbfe36c89de429f3"
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
