require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.11.2.tgz"
  sha256 "84aac7ae4d338ccc85c32822b27a76359d485fa9d1a1e0c3aadbc95a8aaa86f4"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2010ae021ee38bd4e1bf95e08d1167a1b149de0d2ac252dada3e524a3c1168f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2010ae021ee38bd4e1bf95e08d1167a1b149de0d2ac252dada3e524a3c1168f"
    sha256 cellar: :any_skip_relocation, monterey:       "00dfb1f53d52613298a453bdba3c8c25354754d9bf5ea287ec3b986c359b37ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "00dfb1f53d52613298a453bdba3c8c25354754d9bf5ea287ec3b986c359b37ec"
    sha256 cellar: :any_skip_relocation, catalina:       "00dfb1f53d52613298a453bdba3c8c25354754d9bf5ea287ec3b986c359b37ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2010ae021ee38bd4e1bf95e08d1167a1b149de0d2ac252dada3e524a3c1168f"
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
