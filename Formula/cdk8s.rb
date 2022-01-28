require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.86.tgz"
  sha256 "979ea53caae93361a355887d47eef532118c3e1edbaa8000ef5ec0e30ac19d78"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "180866dee1ac499c9f9d0bd053d70408e537082cd2fe8ae5c79c0f345352f52d"
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
