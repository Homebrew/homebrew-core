require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.8.3.tgz"
  sha256 "4cc0d24a24c5c1ded68a8325dcdd3b57fd0af34531292d5ba2a794ae898ad1eb"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0eb51c920c8ae5475bc8f28b5d540c3b69909279f7a4e7981ddc2c3eaa62781"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0eb51c920c8ae5475bc8f28b5d540c3b69909279f7a4e7981ddc2c3eaa62781"
    sha256 cellar: :any_skip_relocation, monterey:       "f5f1f8d7df7632f0944ed1714082fdf7d779841fd94bf4ed89a39791968a1d70"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5f1f8d7df7632f0944ed1714082fdf7d779841fd94bf4ed89a39791968a1d70"
    sha256 cellar: :any_skip_relocation, catalina:       "f5f1f8d7df7632f0944ed1714082fdf7d779841fd94bf4ed89a39791968a1d70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0eb51c920c8ae5475bc8f28b5d540c3b69909279f7a4e7981ddc2c3eaa62781"
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
