require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.4.tgz"
  sha256 "0784c5e664b608105a985882e104de78a371edda26e1600b36d511c404e12bfd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "22dc90cd147bbcd46f1dd4e2b6f6cff6899c953d2c1d961c1ab550af20573584"
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
