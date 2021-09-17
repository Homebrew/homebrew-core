require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.6.1.tgz"
  sha256 "14944600febd1d07ce7a91cad7668c54795f72bc358e9ff6097cb958e43b651d"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "938206cf679491a446d17b648565287c3df691a5e6e3ece8a3a9836758e79fb5"
    sha256 cellar: :any_skip_relocation, big_sur:       "92760d15e35555fc2c1279b1c123d217d706c460158a7ee5f5c5d1b650717098"
    sha256 cellar: :any_skip_relocation, catalina:      "92760d15e35555fc2c1279b1c123d217d706c460158a7ee5f5c5d1b650717098"
    sha256 cellar: :any_skip_relocation, mojave:        "92760d15e35555fc2c1279b1c123d217d706c460158a7ee5f5c5d1b650717098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28c30389960993b3aa57d911e162735e169304845967ef5637fe2f2bf641f358"
  end

  depends_on "node"
  depends_on "terraform"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "ERROR: Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdktf init --template='python' 2>&1", 1)
  end
end
