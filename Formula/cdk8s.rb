require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.124.tgz"
  sha256 "6f2d2f59cec875790fda6e0049fc9fa4ea5d735caec2b995d47a99ae23e77f13"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b51ca8c6bf311419033e15cf45420a643d4e028707c937b3c75e736dcfa00439"
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
