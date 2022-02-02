require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.89.tgz"
  sha256 "2109401b06dec9fee85bb3fc04e777613b6eb15fa6a318e99bca8e73d07bef8a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "56079ac9e6d94d8b2dbe73d44d91aa017b6b27e64f586ce9ee43b9b51aa73e8b"
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
