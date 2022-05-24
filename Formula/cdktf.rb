require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.11.0.tgz"
  sha256 "3f597306e3733fc60cceb5f1beacd3218594be693cc15e9950401696bf6a3c1c"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f043980a5a33af7c4d87ba1fc0597bb4b600236d092c0f962134d4889d3a2acd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f043980a5a33af7c4d87ba1fc0597bb4b600236d092c0f962134d4889d3a2acd"
    sha256 cellar: :any_skip_relocation, monterey:       "2411869606eddde07aa0282971140dee83bc07841773c280adc29983625ee203"
    sha256 cellar: :any_skip_relocation, big_sur:        "2411869606eddde07aa0282971140dee83bc07841773c280adc29983625ee203"
    sha256 cellar: :any_skip_relocation, catalina:       "2411869606eddde07aa0282971140dee83bc07841773c280adc29983625ee203"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f043980a5a33af7c4d87ba1fc0597bb4b600236d092c0f962134d4889d3a2acd"
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
