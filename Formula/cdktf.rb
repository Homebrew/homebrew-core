require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.9.2.tgz"
  sha256 "e06902f9975313f707655562a17191db3f5b488f91bdeb0b9a3e6f2782e47ab8"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb1a980a204676bb4936a6deb08a2d606023fe4573bd1a2800095291fa3d285d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb1a980a204676bb4936a6deb08a2d606023fe4573bd1a2800095291fa3d285d"
    sha256 cellar: :any_skip_relocation, monterey:       "3b7bb061c8b299661b97d98470f5768d375dbb93130a4c4be8453bcd06e5df6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b7bb061c8b299661b97d98470f5768d375dbb93130a4c4be8453bcd06e5df6d"
    sha256 cellar: :any_skip_relocation, catalina:       "3b7bb061c8b299661b97d98470f5768d375dbb93130a4c4be8453bcd06e5df6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb1a980a204676bb4936a6deb08a2d606023fe4573bd1a2800095291fa3d285d"
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
