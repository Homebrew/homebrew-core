class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.58.tgz"
  sha256 "144a5033259c73a6cfe658390c4b586bc93c77b6982334dc7071aabff60143bf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "95f7b1e5dd9ec085b30f37b1bb93c66313295d0ee2fc7b97b298671285d73189"
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
