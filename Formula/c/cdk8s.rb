class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.30.tgz"
  sha256 "4e749b4fc181cf82a879ee753499035221f179d42a52bffe98461e6654c0772f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "96fab01a19424e1057fe9d3111488daefd08f8f0369530d2028d803ae4d86d56"
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
