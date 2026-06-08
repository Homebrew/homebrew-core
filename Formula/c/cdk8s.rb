class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.18.tgz"
  sha256 "b4f3b788fb28bd4534546e3c78633552206eb5c1221364474fc2c8d6542edeaf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0def878c950009e74448d1d8d29df6e84fcb7249230623df8b4a13786a9310f5"
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
