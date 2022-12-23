require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.84.tgz"
  sha256 "1f27cbf5c7532b2ba95aa87e43cfda5a29a9bd41589dba8750681a459432f039"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "65744006e3eeec65f4f2e7b706b2424569234091b9fa9c4dd6a560152fb0197e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end
