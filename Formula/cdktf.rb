require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.6.4.tgz"
  sha256 "36fc5a1def6a2d61f333ec98d90f54b2cd9b124f47487553061de1beef059cd9"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1ae48f199b87c5bcf2a1178b89ddaad89b20c5a71f40fc7733a0b4d6c38688d2"
    sha256 cellar: :any_skip_relocation, big_sur:       "49b67b506cb717ebd756bca918c791d415d289f84709eab66c739b9ddc5b30cb"
    sha256 cellar: :any_skip_relocation, catalina:      "49b67b506cb717ebd756bca918c791d415d289f84709eab66c739b9ddc5b30cb"
    sha256 cellar: :any_skip_relocation, mojave:        "9ff1f2b66bc526ca2ced42ccfa328d1b64b417ce06191c9a13167be12d8c409d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbe6f653844d1adb42b1ccce9c8a9bb3473137729ec6f58461ac9f4f3eb2ccd8"
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
