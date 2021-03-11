require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.2.0.tgz"
  sha256 "6b9e712cad5e42c2efc39147711818a90b007edbb1fe6f7b11599cf3358f66a9"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2aec059a06003bd1eeadbf0955d2353fb26d475565eea4b8c38cfe8e603b1824"
    sha256 cellar: :any_skip_relocation, big_sur:       "2c0c649ff73fa68eea32584e0cbac50f86a5ca920c0493ed0146cf642b06a7d4"
    sha256 cellar: :any_skip_relocation, catalina:      "c84e60b9eded34da028aeb2aeed72931602b42020fa91df0d2d30b6717ff5e83"
    sha256 cellar: :any_skip_relocation, mojave:        "3b6243b546cc8a34c8bbee4bb5df75ef2c098f455fad44f247ede3d8ff8c330d"
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
