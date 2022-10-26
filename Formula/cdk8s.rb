require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.27.tgz"
  sha256 "ad320cc15d66ebcdf78f86832934facc7bc35a97e4dde87ddf4bb3209e793a27"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eecff572f9e40044f492923e4bae4ea9d2b90ae496de816105daa20c0a7107e9"
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
