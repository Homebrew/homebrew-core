class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.206.3.tgz"
  sha256 "929e7e7ac98655e0e61f11d513631401e402d1d561a0c21e99851a8975f85478"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b8e3ae0584556c0f7968ac654451a5203b9e841153325dbe3786df598f1186bc"
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
