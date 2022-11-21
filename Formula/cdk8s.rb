require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.53.tgz"
  sha256 "b1caca1e335fc2876632b39262fe37233f1e5fd0f63d281c26ae748ede09e6df"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0ecc3031bfe3e10a3d719b8eb3747bb4857264003ab53a875f5685b724b378e8"
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
