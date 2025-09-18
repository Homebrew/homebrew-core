class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.29.tgz"
  sha256 "a459ca8cf679209ba7e0bd129424bc6497895daa18123b577c496e1f668023e3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "41c8f783e7b97e5ee8942ba61599a8d82c7ba8a44b1f9ad2093c6812c43d6217"
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
