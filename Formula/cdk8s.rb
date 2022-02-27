require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.110.tgz"
  sha256 "9db801494878ab44088f9758fb2e8b8d86d5b09ab56a11c10af4a4b573031d3f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fe7d2ea4abbe938b0ff6124153700de033d66961ce42a860425331373268194a"
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
