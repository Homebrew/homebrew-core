require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.8.2.tgz"
  sha256 "c536c59a823f0df9889b6f9f9e14b6e107f46ec0b1066f0c482418485407221d"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b70a04a68243f98df05446ede324b44d5724ad2e49bb014df8893e1ecda9bc3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b70a04a68243f98df05446ede324b44d5724ad2e49bb014df8893e1ecda9bc3d"
    sha256 cellar: :any_skip_relocation, monterey:       "360830951ed54d1d209b36d8716197963ab7d2ecc059cbe0dee2de28aa02d321"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d57440281f6447ffa5473d082b48e966fb68f78ae8ae6e62582e582d7aeb9e5"
    sha256 cellar: :any_skip_relocation, catalina:       "6d57440281f6447ffa5473d082b48e966fb68f78ae8ae6e62582e582d7aeb9e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b70a04a68243f98df05446ede324b44d5724ad2e49bb014df8893e1ecda9bc3d"
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
