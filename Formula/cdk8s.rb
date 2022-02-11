require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.95.tgz"
  sha256 "08d789eb5962145087ed8e21ce2c8ac8bbc3462974ac0bcbfc6c1f71544f13df"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "99c1fdbc0e21c152465838dafc7aabf511480725e288412033c35692cad91fc4"
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
