require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.6.4.tgz"
  sha256 "36fc5a1def6a2d61f333ec98d90f54b2cd9b124f47487553061de1beef059cd9"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5211b14565f9dfe36a543aefb50dbf7ffe137916569779bc5988a262e44ad5c2"
    sha256 cellar: :any_skip_relocation, big_sur:       "4bcdddc9413a3291f1801f8b60390c5a9c63731f07da27fdd27b3f6be5b6405f"
    sha256 cellar: :any_skip_relocation, catalina:      "4bcdddc9413a3291f1801f8b60390c5a9c63731f07da27fdd27b3f6be5b6405f"
    sha256 cellar: :any_skip_relocation, mojave:        "4bcdddc9413a3291f1801f8b60390c5a9c63731f07da27fdd27b3f6be5b6405f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0d52c137caa9d9ae67eb3374c3015ade0a869c915a6ba3077be537e29847c19"
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
