require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.90.tgz"
  sha256 "fb26ddeafa1aa48ca9fa07cefd127e80f6276cd781219918197f22edb9f167fe"
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
