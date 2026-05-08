class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.206.10.tgz"
  sha256 "3821e0471a4e0a3e3afc8ead96eb3204b1704c12e46a471ba763e592a39f3a34"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "76bbce09a8e5920024eaf2d7b0f6a0117ad9d475cd62c7ac07c724798d9a1585"
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
