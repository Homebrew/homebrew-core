require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.12.0.tgz"
  sha256 "244a72b7ed5d74dd9d038f433c0d06f8bde72dd5d807d3622cffb88dd6908a71"
  license "MPL-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88c8c7d10d2c9cc9f41ee32d71ca19b668784e6959e499bb9bf74bc09261c972"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88c8c7d10d2c9cc9f41ee32d71ca19b668784e6959e499bb9bf74bc09261c972"
    sha256 cellar: :any_skip_relocation, monterey:       "7203c49050b33568086e239328b752fad06f9a247a1dd52c372bd3eb9c2c7af8"
    sha256 cellar: :any_skip_relocation, big_sur:        "7203c49050b33568086e239328b752fad06f9a247a1dd52c372bd3eb9c2c7af8"
    sha256 cellar: :any_skip_relocation, catalina:       "7203c49050b33568086e239328b752fad06f9a247a1dd52c372bd3eb9c2c7af8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88c8c7d10d2c9cc9f41ee32d71ca19b668784e6959e499bb9bf74bc09261c972"
  end

  depends_on "node"
  depends_on "terraform"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # completion script currently requires --help run without error https://github.com/hashicorp/terraform-cdk/issues/1905
    output = Utils.safe_popen_read({ "SHELL" => "bash" }, libexec/"bin/cdktf", "completion", "--help")
    (bash_completion/"cdktf").write output

    output = Utils.safe_popen_read({ "SHELL" => "zsh" }, libexec/"bin/cdktf", "completion", "--help")
    (zsh_completion/"_cdktf").write output
  end

  test do
    assert_match "ERROR: Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdktf init --template='python' 2>&1", 1)
  end
end
