require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.74.tgz"
  sha256 "93d866d6280ea7bca7cc0e2c80b0efde34f7889e210f0eba93fa6a8652eaa7ad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6e6d2293d602fb8a70f117cd46c858262b431537586a6d9d5e434a0d1926f4fb"
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
