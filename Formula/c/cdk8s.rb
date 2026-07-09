class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.38.tgz"
  sha256 "596808826ce0cb7197f21fb594faa2e061ccaae01f0299e29a84bcf3b0e02b10"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c05f8dc3509b629c9ff6d3b0c785b750ac06346396c70795ea1fcca9fe132882"
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
