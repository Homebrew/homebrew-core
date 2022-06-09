require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.11.2.tgz"
  sha256 "84aac7ae4d338ccc85c32822b27a76359d485fa9d1a1e0c3aadbc95a8aaa86f4"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0394ae89d1d39c4ccd23b230ee42dabe9468738e5fb3427a13749f6b63c5d0a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0394ae89d1d39c4ccd23b230ee42dabe9468738e5fb3427a13749f6b63c5d0a9"
    sha256 cellar: :any_skip_relocation, monterey:       "ed7892a067b3c82d7fda35f46f361d55848d110d5fc02c771528e5bb43307d6e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed7892a067b3c82d7fda35f46f361d55848d110d5fc02c771528e5bb43307d6e"
    sha256 cellar: :any_skip_relocation, catalina:       "ed7892a067b3c82d7fda35f46f361d55848d110d5fc02c771528e5bb43307d6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0394ae89d1d39c4ccd23b230ee42dabe9468738e5fb3427a13749f6b63c5d0a9"
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
