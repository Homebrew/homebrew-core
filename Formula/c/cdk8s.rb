class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.41.tgz"
  sha256 "8e72c26e8062ccd0a85427cd5b4c715a87d10033b180885d9d2a296d36a1582e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8d4811837d8125779a840a43d1d3c3bea86a07d68dcbcfb4f13abc5118e4fead"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
