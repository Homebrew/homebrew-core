require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.116.tgz"
  sha256 "32e56cfd9a798ebecfa1996733297397e7cee7a6cd1c7e4d0c20c3dceae42f9b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d197c3d0e0e7e1fd856b4c81901bcfeefd14c3472f3770a3705301b68603c376"
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
