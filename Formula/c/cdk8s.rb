class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.78.tgz"
  sha256 "fe6569c7f81762189b348727c6c84c8e0a9fc9752611edc39eefbb8edf9d5f83"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b4ad5ea3117a44591d1056ef21d084fcb4e4db4b6dcbba00dfb2c2167f8d3223"
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
