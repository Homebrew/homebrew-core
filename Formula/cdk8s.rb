require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.114.tgz"
  sha256 "733c8bf8c7653a5214c90ab9449e206d145cffce80c514cb8886c7e560946588"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "111ba1f4562b28029d9a76c7f13b677170ec5b1fc259de3abaffe9b2e39b3e5d"
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
