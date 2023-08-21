require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.50.0.tgz"
  sha256 "25c85185a3553d83b40d2ee9f891171be33391c29ed8485ed42ba5426c19bfbf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f13e91b83d2b69b56a413186e00d7cb85321fa7c91f1b65dfb6c7cfdba1201cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f13e91b83d2b69b56a413186e00d7cb85321fa7c91f1b65dfb6c7cfdba1201cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f13e91b83d2b69b56a413186e00d7cb85321fa7c91f1b65dfb6c7cfdba1201cf"
    sha256 cellar: :any_skip_relocation, ventura:        "f2262ca86d65b5344e8980788b3369d9a27e9375a34b1cacafbf1f9f2d2e5bc2"
    sha256 cellar: :any_skip_relocation, monterey:       "f2262ca86d65b5344e8980788b3369d9a27e9375a34b1cacafbf1f9f2d2e5bc2"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2262ca86d65b5344e8980788b3369d9a27e9375a34b1cacafbf1f9f2d2e5bc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f13e91b83d2b69b56a413186e00d7cb85321fa7c91f1b65dfb6c7cfdba1201cf"
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
