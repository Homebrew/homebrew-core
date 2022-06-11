require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.17.tgz"
  sha256 "5cdb23a02a95d57981cdff45d2268f0a8cbcd19da91558501cad8aa25e51adb5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a245795d2f35831367d676aeedd6a05e1f23be6a7731708f78fbd4155ff121b2"
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
