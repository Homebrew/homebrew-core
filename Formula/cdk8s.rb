require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.145.tgz"
  sha256 "13d1093ed97f7affaba25d0641b9136da5c171cdfc110a834db97627f5b0aeec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b40293f1bb88d2ed660061383db8aece6bf4da7704e41b50a08babb03e23746d"
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
