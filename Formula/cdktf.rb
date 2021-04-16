require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.2.2.tgz"
  sha256 "48fbd5896b936bcae1506fa2076f44790c06a862ec9321fd7bb7fff56de68adf"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f010eea2ab21bac1048b27b5202b5cfb9d50c87de73035e98cd07758f8144715"
    sha256 cellar: :any_skip_relocation, big_sur:       "7699e0581f1a128f9c1658281d1cde56c88be2cc8ba008a1873f6aa9ec901f7a"
    sha256 cellar: :any_skip_relocation, catalina:      "91f4daf68a3b5d01b7e4e873abb9c3380b72a830185b6dd94f3debfdfbc26163"
    sha256 cellar: :any_skip_relocation, mojave:        "4f2df03511155efc481b6378eeec8ef43142185b5728aa90c2076e4b640b8a7a"
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
