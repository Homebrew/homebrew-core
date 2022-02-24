require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.107.tgz"
  sha256 "e983a5c1943099092f3c1d911f1defbd0f14bfe315d9ded2f09e73de2bd0fa87"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0e073c181fce87272d9dc3260bcaad380a23e76d9e8e7274ec068acafdcd2b4b"
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
