require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.5.0.tgz"
  sha256 "245768d2698bfe2bf8f38128b4d5f3fd5fe8988d95aaaebe71237143379f1d99"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e3eec367595428ca394c5bc7f006a996dbbff0c6b1a107bc8958336bf55515bf"
    sha256 cellar: :any_skip_relocation, big_sur:       "49e708d3fa251a7e3b4e21ec5d8b4bd05718e85898d0f1aca1dfb557f7e07658"
    sha256 cellar: :any_skip_relocation, catalina:      "49e708d3fa251a7e3b4e21ec5d8b4bd05718e85898d0f1aca1dfb557f7e07658"
    sha256 cellar: :any_skip_relocation, mojave:        "49e708d3fa251a7e3b4e21ec5d8b4bd05718e85898d0f1aca1dfb557f7e07658"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "915d748f0555600f8e63bf6f122887745b9bf1fdb255323824b5b02a922be3b2"
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
