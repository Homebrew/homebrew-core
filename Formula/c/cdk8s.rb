class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.1.tgz"
  sha256 "382c7ecbc63a18c7bd251ee4f2e4fc6a426d67e25b7c4b7a1db278f2913133a6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e95e8ef30ace133f27099cec5387d8edf42d2ce3ecda3adcc1b2e53c22c21ab9"
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
