require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.23.tgz"
  sha256 "0e350c4fe01ded3cf46f59b9349ef5c1919f4e09964357b277608b5ae8a1b87f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "135e3946bc1f9e7f45275ec0193e8d9a6de8891dbbc6132298de7e8eecb99a4a"
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
