require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://github.com/awslabs/cdk8s"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.0-beta.4.tgz"
  sha256 "0308e8942820c8b739c8df5e2296b4d497b530b8b088816e02bdff1e7aab2dae"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5a974f74c2510849e093b0286aeb9d48bcadeb67caecb60108396b32314a0dfa" => :big_sur
    sha256 "6a183f35fa611a82475eeb6ce8814bfcd3b06ef0fa26f19830a6e69ca9328426" => :catalina
    sha256 "094a4e184bf640dced7744a154140b6ec87d2c1c62d381ead9d695ad1dc05c39" => :mojave
    sha256 "8fd5ae70cb00cf12f8d9ad75eef53e99f9b3ced3fa0987bbcc88c9fda81313d2" => :high_sierra
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
