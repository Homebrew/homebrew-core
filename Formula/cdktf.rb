require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.10.1.tgz"
  sha256 "fcce7ef97a47b7bd6660e526d561b604b191b2ce935ef926bdbca57396e9f5f1"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9815d0e38e4a9d2f968a977ae354afb26f9e76d3113a29e33fef21cecf36811"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9815d0e38e4a9d2f968a977ae354afb26f9e76d3113a29e33fef21cecf36811"
    sha256 cellar: :any_skip_relocation, monterey:       "ddbc8f61ab8683ab81b27b819b99d64d687f72b6d932d243e75249fc76635544"
    sha256 cellar: :any_skip_relocation, big_sur:        "ddbc8f61ab8683ab81b27b819b99d64d687f72b6d932d243e75249fc76635544"
    sha256 cellar: :any_skip_relocation, catalina:       "ddbc8f61ab8683ab81b27b819b99d64d687f72b6d932d243e75249fc76635544"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9815d0e38e4a9d2f968a977ae354afb26f9e76d3113a29e33fef21cecf36811"
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
