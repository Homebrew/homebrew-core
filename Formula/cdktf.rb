require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.9.1.tgz"
  sha256 "13e01c033cb82e3857660490c8e587a1128a23836e4ef9157deebd756a06d057"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "436d3c64391b95ccc8e55eb378a5f88877220ef644a9f9da68334065da97b4c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "436d3c64391b95ccc8e55eb378a5f88877220ef644a9f9da68334065da97b4c6"
    sha256 cellar: :any_skip_relocation, monterey:       "a9bcf6f0277ed44f506b56bd584bce5b03208579af5adb49de3b380891ad9fd9"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9bcf6f0277ed44f506b56bd584bce5b03208579af5adb49de3b380891ad9fd9"
    sha256 cellar: :any_skip_relocation, catalina:       "a9bcf6f0277ed44f506b56bd584bce5b03208579af5adb49de3b380891ad9fd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "436d3c64391b95ccc8e55eb378a5f88877220ef644a9f9da68334065da97b4c6"
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
