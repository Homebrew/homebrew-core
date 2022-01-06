require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.8.5.tgz"
  sha256 "f9c5c9a1280428840a8892227d09e71420bf630a75555249d25c937fd9423931"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12ad9a0b770eb03639fd206e5d221f5eee6089d5e95d613ea5b20ad685de7137"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12ad9a0b770eb03639fd206e5d221f5eee6089d5e95d613ea5b20ad685de7137"
    sha256 cellar: :any_skip_relocation, monterey:       "f15e189fa70694520ce8721da110f20fb4e4bdc351dfbbadbb5969cdf8bad488"
    sha256 cellar: :any_skip_relocation, big_sur:        "f15e189fa70694520ce8721da110f20fb4e4bdc351dfbbadbb5969cdf8bad488"
    sha256 cellar: :any_skip_relocation, catalina:       "f15e189fa70694520ce8721da110f20fb4e4bdc351dfbbadbb5969cdf8bad488"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12ad9a0b770eb03639fd206e5d221f5eee6089d5e95d613ea5b20ad685de7137"
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
