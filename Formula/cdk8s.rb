require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.80.tgz"
  sha256 "284472893e32d65b0b00dced1a9a630dc0241183f9a1f7b27467923455b6e7f0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f4948389b187edf13341910e09457b2e6d301cc674db1ae8dddcda4e9fd00ca7"
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
