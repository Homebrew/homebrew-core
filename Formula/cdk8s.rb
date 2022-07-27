require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.65.tgz"
  sha256 "63e876048721d90b5815704b1efe911c8299c5380e334f72763ebd8fc2374fa3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "72dff9649fa03c4a736d6c00f9775c9185c9fcfdc0db30f4e621515035ddee3f"
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
