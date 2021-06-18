require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.4.1.tgz"
  sha256 "0baa6a42417eb4719f6e8d269c231ac04f80ce5e9f1719a0e650fb1a6ee4633a"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e3eec367595428ca394c5bc7f006a996dbbff0c6b1a107bc8958336bf55515bf"
    sha256 cellar: :any_skip_relocation, big_sur:       "49e708d3fa251a7e3b4e21ec5d8b4bd05718e85898d0f1aca1dfb557f7e07658"
    sha256 cellar: :any_skip_relocation, catalina:      "49e708d3fa251a7e3b4e21ec5d8b4bd05718e85898d0f1aca1dfb557f7e07658"
    sha256 cellar: :any_skip_relocation, mojave:        "49e708d3fa251a7e3b4e21ec5d8b4bd05718e85898d0f1aca1dfb557f7e07658"
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
