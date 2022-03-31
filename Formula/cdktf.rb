require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.10.0.tgz"
  sha256 "ce9b49c645823fc93d99b12be74c5080c5e54f28bd06da22aead200d4e361163"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c9901c2329a4ce8e229bff82a0eef75358930be5fc03dbd606eada2c64bd85e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c9901c2329a4ce8e229bff82a0eef75358930be5fc03dbd606eada2c64bd85e"
    sha256 cellar: :any_skip_relocation, monterey:       "5ed67e27435ba364e817db865883f3b872b5de5ce10cf89ebda857fa8c2f91ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ed67e27435ba364e817db865883f3b872b5de5ce10cf89ebda857fa8c2f91ae"
    sha256 cellar: :any_skip_relocation, catalina:       "5ed67e27435ba364e817db865883f3b872b5de5ce10cf89ebda857fa8c2f91ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c9901c2329a4ce8e229bff82a0eef75358930be5fc03dbd606eada2c64bd85e"
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
