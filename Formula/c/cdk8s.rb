class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.28.tgz"
  sha256 "c15661cf527b797ed7a12de231c22f48ba4a1d689b048f246cbe5ab24c360e11"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eb24ce76c644a9ae4cf1effad96a1de6c85d84d3a81c79d4fbac869213d015ea"
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
