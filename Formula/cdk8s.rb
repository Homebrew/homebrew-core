require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.10.tgz"
  sha256 "534022a35c09810afc2cd00660889ac81dac1588761e8d0628c0e37acf8201a8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "09c6ea02e8258ff36c1b053c89f5051106ad8e4e9bfc049cac2265ebd72bde35"
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
