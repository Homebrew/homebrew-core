require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://github.com/awslabs/cdk8s"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-0.32.0.tgz"
  sha256 "88f78e0d015e5ab5bbf1c0254946b31d59c274a5fc02513204a695812b9d57fe"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "bd2f4523dcd897c1656887eb14af0cb9215c7d2d4f306de1167078994685a5a0" => :catalina
    sha256 "94a1dbbf25c96424865c2c106dd3e47ccf3298afc56f8e2ac1dc9bef3e9ab80c" => :mojave
    sha256 "9c6a931330467a53d7e26f701687bc68b53427c3dc17f3065338c122292fb167" => :high_sierra
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
