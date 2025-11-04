class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.202.12.tgz"
  sha256 "8753a3d8bd4d3b920710fcd8a1d31cb0eb161eead6b06b8d98fa5e9be06ddd75"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "285ef948cef1b1b4a8eb09c8284bf92e7d81a02db0e3fa2a4a2b342632565af1"
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
