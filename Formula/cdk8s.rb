require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.29.tgz"
  sha256 "408ea4ce9869cee8406811f1ebf08bc27c1ebea12ce461335b72fee741e9418c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "712dbc95542ac8c122e3982808a0efdc82dd8e69ea2a0f7aef15308f1eecdc3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "712dbc95542ac8c122e3982808a0efdc82dd8e69ea2a0f7aef15308f1eecdc3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "712dbc95542ac8c122e3982808a0efdc82dd8e69ea2a0f7aef15308f1eecdc3e"
    sha256 cellar: :any_skip_relocation, ventura:        "6b98d98f07a9a4160a8a0cc281a9a2ecab3207e9db8f6fd1fdacf2bd0fa451c5"
    sha256 cellar: :any_skip_relocation, monterey:       "6b98d98f07a9a4160a8a0cc281a9a2ecab3207e9db8f6fd1fdacf2bd0fa451c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b98d98f07a9a4160a8a0cc281a9a2ecab3207e9db8f6fd1fdacf2bd0fa451c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "712dbc95542ac8c122e3982808a0efdc82dd8e69ea2a0f7aef15308f1eecdc3e"
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
